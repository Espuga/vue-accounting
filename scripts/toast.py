import sys

if len(sys.argv) == 2:
  file = "./../src/"+sys.argv[1]

  with open(file, 'r') as f:
    lines = f.readlines()

  wf = open(file, 'w')
  for line in lines:
    if "toast.add" in line:
      spaces = line.split("toast")[0]
      splited = line.split("{")[1].split("}")[0].split("',")
      aux = spaces+"toast.toast('"+splited[0].split(': \'')[1]+"', '"+splited[1].split(': \'')[1]+"', '"+splited[2].split(': \'')[1]+"')\n"
      # print(aux)
      wf.write(aux)
    elif "loading." in line:
      spaces = line.split("loading")[0]
      splited = line.split("=")[1].strip()
      aux = spaces+"loading.load("+splited+")\n"
      wf.write(aux)
    else:
      wf.write(line)
  print("Fet")
else: 
  print("Usage: python3 toast.py components/settings/changeTelegramAlertChatComponent.vue")