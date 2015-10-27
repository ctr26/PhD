cmd = getArgument();
string = split(cmd, ",");
print(cmd);
order =  string[0];
channels = parseInt(string[1]);
slices =  parseInt(string[2]);
frames =  parseInt(string[3]);
dir = getDirectory("image")
file = getInfo("image.filename")
print("Creating hyper Stack");
print(dir+file)
run("Stack to Hyperstack...", "order=&order channels=&channels slices=&slices frames=&frames display=Color");
print("Saving");
saveAs("Tiff", dir + file);
print("Fin");
