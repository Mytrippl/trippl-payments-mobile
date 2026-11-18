from pathlib import Path
import hashlib,json
root=Path(__file__).resolve().parents[1]
rows=[]
for p in sorted((root/'lib').rglob('*.dart')):
    data=p.read_bytes()
    rows.append({'path':p.relative_to(root).as_posix(),'physicalLines':len(data.splitlines()),'sha256':hashlib.sha256(data).hexdigest()})
print(json.dumps({'productionDartFiles':len(rows),'productionDartPhysicalLines':sum(r['physicalLines'] for r in rows),'files':rows},indent=2))
