from pathlib import Path
import argparse,gzip,hashlib,io,json,subprocess,tarfile
root=Path(__file__).resolve().parents[1]
def git(*args):return subprocess.check_output(['git',*args],cwd=root)
def package(destination):
    if git('status','--porcelain').strip():raise SystemExit('Commit tracked source changes before packaging.')
    commit=git('rev-parse','HEAD').decode().strip()
    files=git('ls-tree','-r','--name-only','HEAD').decode().splitlines()
    rows=[]
    destination.mkdir(parents=True,exist_ok=True)
    output=destination/'trippl-payments-mobile-source.tar.gz'
    with output.open('wb') as stream:
        with gzip.GzipFile(filename='',fileobj=stream,mode='wb',mtime=0) as compressed:
            with tarfile.open(fileobj=compressed,mode='w') as archive:
                for name in files:
                    data=git('show',f'HEAD:{name}')
                    entry=tarfile.TarInfo('trippl-payments-mobile/'+name)
                    entry.size=len(data);entry.mode=0o644;entry.mtime=0
                    archive.addfile(entry,io.BytesIO(data))
                    rows.append({'path':name,'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest()})
    digest=hashlib.sha256(output.read_bytes()).hexdigest()
    output.with_suffix(output.suffix+'.sha256').write_text(digest+'  '+output.name+'\n')
    output.with_suffix(output.suffix+'.manifest.json').write_text(json.dumps({'commit':commit,'sourceTree':git('rev-parse','HEAD^{tree}').decode().strip(),'sha256':digest,'files':rows},indent=2)+'\n')
    with tarfile.open(output,'r:gz') as archive:
        for row in rows:
            content=archive.extractfile('trippl-payments-mobile/'+row['path']).read()
            if hashlib.sha256(content).hexdigest()!=row['sha256']:raise SystemExit('Archive verification failed')
    json.loads(output.with_suffix(output.suffix+'.manifest.json').read_text())
    if output.with_suffix(output.suffix+'.sha256').read_text().split()[0]!=digest:raise SystemExit('Checksum manifest verification failed')
    print(output)
if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('--output',type=Path,default=root/'dist');args=parser.parse_args();package(args.output)
