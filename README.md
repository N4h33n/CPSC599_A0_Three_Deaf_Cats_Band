Upload StandardFirmata.ino to the Arduino first.
The data folder inside BeatWrite folder needs to contain the desired mp3 file. I did not upload any audio files to github. Make sure to change the filename
variable in BeatWrite.pde.
Run BeatWrite.pde which is inside BeatWrite, ensuring that the port the code is readin from is the correct port that the Arduino is connected to.
Press button on Arduino to play music. Press again to pause.
BeatWrite.pde contains the arduino code, where it makes use of the cc.arduino library through which I was able to write arduino code inside a .pde file.
