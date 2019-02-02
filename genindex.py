import yaml, re

with open('mkdocs.yml','r') as fichero1:
	datos=yaml.load(fichero1)
fichero1.closed

indices=datos['nav'][1]['Blog']


fichero2 = open('docs/index.md','w+')

for i in indices:
	fichero2.seek(0,0)
	contenido = fichero2.read()
	fichero2.seek(0,0)
	for clave,valor in i.items():
		linea=''
		with open('docs/'+valor,'r') as fichero3:
			for linea2 in fichero3:
				if re.compile('^# ').match(linea2):
					linea+='['+linea2.strip('# ').strip('\n')+']'+'('+valor+'#header1'+')'+'\n\n'
				elif re.compile('^[a-zA-Z]').match(linea2):
					linea+=linea2+'\n'
				elif re.compile('^## ').match(linea2):
					break
				else:
					continue
		fichero2.write(linea+'***\n'+'\n'+contenido)

fichero2.seek(0,0)
contenido = fichero2.read()
fichero2.seek(0,0)
fichero2.write('# Bienvenido al Rincón Vacío\n\n'+contenido)

fichero2.close()
