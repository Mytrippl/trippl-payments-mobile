from pathlib import Path
import json
ROOT=Path(__file__).resolve().parents[1]
models=json.loads((ROOT/'tool/payment_models.json').read_text())
lookup={m[0]:m[1] for m in models}
MODEL_RULES=json.loads((ROOT/'tool/payment_rules.json').read_text())
def typ(t):return 'DateTime' if t in ['day','instant'] else 'int' if t in ['signedInt','signedAmount'] else t
def nullable(f):return not f[2] and f[3] is None
def dtype(f):return typ(f[1])+('?' if nullable(f) else '')
def q(v):return json.dumps(v)
def decode(f):
 n,t,req,default=f;required=', required: true' if req else ''
 if t=='String' and n=='rawText':s=f"PaymentCodec.verbatim(json, '{n}'{required})"
 elif t=='String':s=f"PaymentCodec.text(json, '{n}'{required}"+(', maximum: 100000' if n=='content' else '')+')'
 elif t in ['int','signedInt','signedAmount']:s=f"PaymentCodec.integer(json, '{n}'{required}, minimum: {-9000000000000 if t=='signedAmount' else -840 if t=='signedInt' else 0}, maximum: {840 if t=='signedInt' else 9000000000000})"
 elif t=='double':s=f"PaymentCodec.decimal(json, '{n}'{required})"
 elif t=='bool':s=f"PaymentCodec.boolean(json, '{n}'{required})"
 elif t in ['day','instant']:s=f"PaymentCodec.date(json, '{n}'{required}{', calendar: true' if t=='day' else ''})"
 elif t=='List<String>':s=f"PaymentCodec.list(json, '{n}', (v) {{ if(v is! String || v.trim().isEmpty || v.length>200) throw const FormatException('Invalid list text'); return v; }}{required}, maximum: {300 if n=='countryCodes' else 100})"
 elif t.startswith('List<'):
  inner=t[5:-1];s=f"PaymentCodec.list(json, '{n}', (v) => {inner}.fromJson(PaymentCodec.object(v)){required}, maximum: {300 if n in ['countries','requirements','access'] else 100})"
 else:s=f"json['{n}'] == null ? null : {t}.fromJson(PaymentCodec.object(json['{n}']))"
 if default is not None:s+=' ?? '+q(default)
 elif req:s='('+s+')!' if t in lookup else s+'!'
 return s
def emit(model):
 name,file,fields=model
 imports={"import '../payment_codec.dart';","import '../payment_issue.dart';"}
 for _,t,*_ in fields:
  t=t[5:-1] if t.startswith('List<') else t
  if t in lookup:imports.add(f"import '{lookup[t]}.dart';")
 lines=['// Generated typed payment records. Edit tool/payment_models.json and regenerate.',*sorted(imports),'',f'class {name} {{',f'  {name}({{']
 for f in fields:
  n,t,req,default=f
  if t.startswith('List<'):lines.append(f'    {typ(t)}'+('?' if nullable(f) else '')+f' {n}'+('' if default is None else ' = '+('const ' if isinstance(default,list) else '')+q(default))+',')
  else:lines.append(('    required ' if req else '    ')+f'this.{n}'+('' if default is None else ' = '+('const ' if isinstance(default,list) else '')+q(default))+',')
 lists=[f for f in fields if f[1].startswith('List<')]
 # Required list parameters are checked by the constructor instead of a nullable assignment.
 for f in lists:
  if f[2]:lines=[line.replace(f'    {f[1]} {f[0]},',f'    required {f[1]} {f[0]},') for line in lines]
 lines+=['  })'+(' : '+', '.join(f"{f[0]} = "+(f"{f[0]} == null ? null : List.unmodifiable({f[0]})" if nullable(f) else f'List.unmodifiable({f[0]})') for f in lists) if lists else '')+';','']
 lines += [f'  final {dtype(f)} {f[0]};' for f in fields]+['',f'  factory {name}.fromJson(Map<String,Object?> json) {{',"    PaymentCodec.keys(json, {"+', '.join(q(f[0]) for f in fields)+"});",f'    final value={name}(']+[f'      {f[0]}: {decode(f)},' for f in fields]+['    );','    final issues=value.validate();','    if(issues.any((i)=>i.severity==PaymentSeverity.error))throw PaymentValidationException(issues);','    return value;','  }','',f'  static PaymentResult<{name}> tryDecode(Object? input) {{','    try {',f'      return PaymentResult(value:{name}.fromJson(PaymentCodec.object(input)));','    } on PaymentValidationException catch(e) {','      return PaymentResult(issues:e.issues);','    } on FormatException {',"      return PaymentResult(issues:const [PaymentIssue('record','format','Payment record has invalid fields or values')]);",'    }','  }','',f'  {name} copyWith({{Set<String> clear=const {{}},']+[f'    {typ(f[1])}? {f[0]},' for f in fields]+['  }) {',"    final clearableFields=<String>{"+', '.join(q(f[0]) for f in fields if nullable(f))+"};", "    if(clear.any((key)=>!clearableFields.contains(key)))throw const FormatException('Only optional fields may be cleared');",f'    return {name}(']+[f'      {f[0]}: '+(f"clear.contains('{f[0]}') ? null : " if nullable(f) else '')+f'({f[0]} ?? this.{f[0]}),' for f in fields]+['    );','  }','','  List<PaymentIssue> validate() {','    final validationIssues=<PaymentIssue>[];']
 for f in fields:
  n,t,req,default=f;maximumText=100000 if n=='content' else 4000;guard=f'if({n} != null) ' if nullable(f) else '';v=n+('!' if nullable(f) else '')
  if t=='String' and n in ['text','rawText']:lines.append(f"    {guard}{{if({v}.length>{maximumText})validationIssues.add(const PaymentIssue('{n}','text','Use bounded text'));}}")
  elif t=='String':lines.append(f"    {guard}{{if({v}.trim().isEmpty || {v}.length>{maximumText})validationIssues.add(const PaymentIssue('{n}','text','Use nonempty bounded text'));}}")
  elif t in ['int','signedInt','signedAmount']:lines.append(f"    {guard}{{if({v} < {-9000000000000 if t=='signedAmount' else -840 if t=='signedInt' else 0} || {v} > {840 if t=='signedInt' else 9000000000000})validationIssues.add(const PaymentIssue('{n}','range','Number is outside the payment limits'));}}")
  elif t=='double':lines.append(f"    {guard}{{if(!{v}.isFinite)validationIssues.add(const PaymentIssue('{n}','finite','Use a finite coordinate or weight'));}}")
  elif t.startswith('List<'):
   lines.append(f"    {guard}{{if({v}.length>{300 if n in ['countries','countryCodes','requirements','access'] else 100}{f' || {v}.isEmpty' if req else ''})validationIssues.add(const PaymentIssue('{n}','count','Payment list is empty or exceeds its limit'));}}")
   if t=='List<String>':lines.append(f"    {guard}{{if({v}.any((item)=>item.trim().isEmpty || item.length>200))validationIssues.add(const PaymentIssue('{n}','text','Use bounded nonempty list text'));}}")
   if t!='List<String>':lines.append(f"    {guard}{{for(var i=0;i<{v}.length;i++)for(final issue in {v}[i].validate())validationIssues.add(PaymentIssue('{n}[$i].${{issue.field}}',issue.code,issue.message,severity:issue.severity));}}")
  elif t in lookup:lines.append(f"    {guard}{{for(final issue in {v}.validate())validationIssues.add(PaymentIssue('{n}.${{issue.field}}',issue.code,issue.message,severity:issue.severity));}}")






 rule=MODEL_RULES.get(name)
 if rule: lines.append(rule+"validationIssues.add(const PaymentIssue('record','contract','Record violates its domain constraints'));")
 lines += ['    return List.unmodifiable(validationIssues);','  }','','  Map<String,Object?> toJson()=>{']
 for f in fields:
  n,t,req,default=f;v=n+('!' if nullable(f) else '')
  val=f'PaymentCodec.calendarText({v})' if t=='day' else f'{v}.toUtc().toIso8601String()' if t=='instant' else f'{v}.map((item)=>item.toJson()).toList()' if t.startswith('List<')and t!='List<String>' else f'{v}.toJson()' if t in lookup else n
  lines.append(('    if('+n+' != null) ' if nullable(f) else '    ')+q(n)+': '+val+',')
 lines+=['  };','',f'  @override bool operator==(Object other)=>other is {name} && PaymentCodec.same(toJson(),other.toJson());','  @override int get hashCode=>PaymentCodec.digest(toJson()).hashCode;',f"  @override String toString()=>'{name}(redacted)';",'}','']
 return '\n'.join(lines)

for model in models:
 p=ROOT/'lib/payment_core/models'/(model[1]+'.dart');p.parent.mkdir(parents=True,exist_ok=True);p.write_text(emit(model))
