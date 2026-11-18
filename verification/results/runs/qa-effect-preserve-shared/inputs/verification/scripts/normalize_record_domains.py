"""Exact TLA record-comprehension to native record-set normalization.

{[fi |-> v[i]] : v in D1 X ... X Dn} = [f1:D1,...,fn:Dn].
We accept only an exact sequential tuple/field bijection and preserve every
domain factor verbatim. No action, state field, guard or assertion is rewritten.
This avoids Apalache expanding function sets inside a Cartesian comprehension.
"""
import re,hashlib
def sha(s):return hashlib.sha256(s.encode()).hexdigest()
def factors(s):
 stack=[];result=[];start=0;i=0
 while i<len(s):
  c=s[i]
  if c in '([{':stack.append(c)
  elif c in ')]}':
   if not stack or '([{'.index(stack.pop())!=')]}'.index(c):raise ValueError('Unbalanced domain')
  if s.startswith('\\X',i) and not stack:
   result.append(s[start:i].strip());start=i+2;i+=1
  i+=1
 if stack:raise ValueError('Unbalanced domain')
 result.append(s[start:].strip())
 if not all(result):raise ValueError('Empty domain')
 return result
def normalize(text):
 records=[]
 for name in ['StateSpace']:
  m=re.search(r'^'+name+r' ==\n(.*?)(?=\n\n)',text,re.M|re.S)
  if not m:raise ValueError('Missing unique domain '+name)
  if len(re.findall(r'^'+name+r' ==',text,re.M))!=1:raise ValueError('Ambiguous domain')
  b=re.fullmatch(r'\s*\{\s*\(\[(.*?)\]\):\s*(\w+)\s*\\in\s*(.*?)\s*\}\s*',m[1],re.S)
  if not b:raise ValueError('Unsupported constructor '+name)
  field_pattern=r'(\w+)\s*\|->\s*'+re.escape(b[2])+r'\[(\d+)\]'
  fields=re.findall(field_pattern,b[1]);rest=re.sub(field_pattern,'',b[1])
  if rest.replace(',','').strip():raise ValueError('Nontrivial field value')
  domains=factors(b[3])
  if [int(i) for _,i in fields]!=list(range(1,len(domains)+1)):raise ValueError('Not an exact sequential tuple-field bijection')
  if len(set(f for f,_ in fields))!=len(fields):raise ValueError('Duplicate field')
  replacement='  [\n'+',\n'.join('    '+f+': ('+d+')' for (f,_),d in zip(fields,domains))+'\n  ]'
  records.append({'operator':name,'before_sha256':sha(m[1]),'after_sha256':sha(replacement),'fields':[f for f,_ in fields],'domains':domains,'identity':'exact sequential product-record comprehension equals native record set'})
  text=text[:m.start(1)]+replacement+text[m.end(1):]
 return text,records
