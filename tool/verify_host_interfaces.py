from pathlib import Path
import json,re
root=Path(__file__).resolve().parents[1]
def signatures(text):
    text=re.sub(r'//[^\n]*','',text)
    pattern=r'^[A-Za-z_][\w<>,? ]* ([A-Za-z_]\w*)\s*\((.*?)\)\s*(?:async\s*)?\{'
    return {name:re.sub(r'\s+','',args) for name,args in re.findall(pattern,text,re.M|re.S)}
if __name__=='__main__':
    expected=json.loads((root/'tool/host_interfaces.json').read_text())
    for path,contracts in expected.items():
        if path.startswith('__'): continue
        actual=signatures((root/path).read_text())
        for name,args in contracts.items():
            if actual.get(name,'').rstrip(',')!=args.rstrip(','): raise SystemExit(f'Host interface changed: {path}: {name}')
    print(f'Host parameter interfaces match across {len(expected)-1} original files.')


widget=root/'lib/custom_code/widgets/stripe_card_field.dart'
import re
constructor=re.search(r'const StripeCardField\(.*?\);',widget.read_text(),re.S)
expected=json.loads((root/'tool/host_interfaces.json').read_text())['__widgetConstructor']
if constructor is None or re.sub(r'\s+','',constructor.group())!=expected:
    raise SystemExit('StripeCardField constructor changed')
print('StripeCardField constructor matches the original host interface.')
