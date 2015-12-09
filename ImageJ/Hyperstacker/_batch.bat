setlocal
cd /d %~dp0
java -jar ij.jar -open test.tif -batch hyper.ijm "xyczt(default),0001,0005,0002"