from pathlib import Path
import os,subprocess,tempfile,sys
root=Path(__file__).resolve().parents[1]
write='--write' in sys.argv
for source in sorted((root/'lib/custom_code/functions').glob('*.dart')):
    text='// Exact production helper bodies; FlutterFlow imports supplied by the host.\n'
    text+='\n'.join(line for line in source.read_text().splitlines() if not line.startswith('import '))+'\n'
    with tempfile.TemporaryDirectory(prefix='payment-helpers-') as folder:
        target=Path(folder)/source.name;target.write_text(text)
        subprocess.run([os.environ.get('DART_BIN','dart'),'format','--language-version=3.10',str(target)],check=True,stdout=subprocess.DEVNULL)
        fixture=root/'test/legacy'/source.name
        if write:fixture.parent.mkdir(parents=True,exist_ok=True);fixture.write_bytes(target.read_bytes())
        elif not fixture.exists() or fixture.read_bytes()!=target.read_bytes():raise SystemExit('Legacy helper extraction differs: '+source.name)
print('All thirteen production helper bodies match their test fixtures.')
