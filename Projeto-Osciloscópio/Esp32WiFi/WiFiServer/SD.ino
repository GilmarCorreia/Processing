
void listDir(fs::FS &fs, String dirname, uint8_t levels){
    Serial.println();
    Serial.println("===================================");
    if(dirname.lastIndexOf('/') != 0)
      dirname.remove(dirname.lastIndexOf('/'),dirname.length()); 
    Serial.println("Listing directory: " + dirname);

    File root = fs.open(dirname);
    if(!root){
        Serial.println("Failed to open directory");
        return;
    }
    if(!root.isDirectory()){
        Serial.println("Not a directory");
        return;
    }

    File file = root.openNextFile();
    while(file){
        if(file.isDirectory()){
            Serial.print("  DIR : ");
            Serial.println(file.name());
            if(levels){
                listDir(fs, file.name(), levels -1);
            }
        } else {
            Serial.print("  FILE: ");
            Serial.print(file.name());
            Serial.print("  SIZE: ");
            Serial.println(file.size());
        }
        file = root.openNextFile();
    }
    Serial.println("===================================");
    Serial.println();
}

void createDir(fs::FS &fs, String path){
    Serial.println();
    Serial.println("===================================");
    Serial.println("Creating Dir: " + path);
    if(fs.mkdir(path)){
        Serial.println("Dir created");
    } else {
        Serial.println("mkdir failed");
    }

    Serial.println("===================================");
    Serial.println();
}

void removeDir(fs::FS &fs, String path){
    Serial.println();
    Serial.println("===================================");
    Serial.println("Removing Dir: " +  path);
    if(fs.rmdir(path)){
        Serial.println("Dir removed");
    } else {
        Serial.println("rmdir failed");
    }
    Serial.println("===================================");
    Serial.println();
}

void readFile(fs::FS &fs, String path){
    Serial.println();
    Serial.println("===================================");
    Serial.println("Reading file: " +  path);

    File file = fs.open(path);
    if(!file){
        Serial.println("Failed to open file for reading");
        return;
    }

    Serial.print("Read from file: ");
    while(file.available()){
        Serial.write(file.read());
    }
    file.close();
    Serial.println("===================================");
    Serial.println();
}

void writeFile(fs::FS &fs, String path, String message){
    Serial.println();
    Serial.println("===================================");
    Serial.println("Writing file: " +  path);

    File file = fs.open(path, FILE_WRITE);
    if(!file){
        Serial.println("Failed to open file for writing");
        return;
    }
    if(file.print(message)){
        Serial.println("File written");
    } else {
        Serial.println("Write failed");
    }
    file.close();
    Serial.println("===================================");
    Serial.println();
}

void appendFile(fs::FS &fs, String path, String message){
    Serial.println();
    Serial.println("===================================");
    Serial.println("Appending to file: " +  path);

    File file = fs.open(path, FILE_APPEND);
    if(!file){
        Serial.println("Failed to open file for appending");
        return;
    }
    if(file.print(message)){
        Serial.println("Message appended");
    } else {
        Serial.println("Append failed");
    }
    file.close();
    Serial.println("===================================");
    Serial.println();
}

void appendFile(fs::FS &fs, File file, String path, char message){
    if(!file){
        //Serial.println("Failed to open file for appending");
        return;
    }
    if(file.print(message)){
        //Serial.println("Message appended");
    } else {
        //Serial.println("Append failed");
    }
}

void renameFile(fs::FS &fs, String path1, String path2){
    Serial.println();
    Serial.println("===================================");
    Serial.println("Renaming file "+  path1 + " to " + path2);
    if (fs.rename(path1, path2)) {
        Serial.println("File renamed");
    } else {
        Serial.println("Rename failed");
    }
    Serial.println("===================================");
    Serial.println();
}



void deleteFile(fs::FS &fs, String path){
    Serial.println();
    Serial.println("===================================");
    Serial.println("Deleting file: " +  path);
    if(fs.remove(path)){
        Serial.println("File deleted");
    } else {
        Serial.println("Delete failed");
    }
    Serial.println("===================================");
    Serial.println();
}

void printSpace(){
  Serial.printf("Total space: %lluMB\n", SD.totalBytes() / (1024 * 1024));
  Serial.printf("Used space: %lluMB\n", SD.usedBytes() / (1024 * 1024));
}

void SerialConfig(String texto1){

    //String texto1 = //Serial.readString();
    String texto2 = texto1;
    int index = texto1.indexOf(' ');
    
    if(!(index == -1)){
      texto2.remove(0,index+1);
      texto2.remove(texto2.indexOf('\n'),1);
    }
    else{
      index = texto1.indexOf('\n');
      texto2.remove(0,texto1.length());
    }

    texto1.remove(index,texto1.length());
    
    //Serial.print(texto1);
    //Serial.print(" ");
    //Serial.println(texto2);
  
    if(texto1.equals("ls"))
      listDir(SD,caminho,0);
    else if(texto1.equals("cd")){
      if(texto2.equals("..")){
        if(caminho.lastIndexOf('/') != 0){
          caminho.remove(caminho.lastIndexOf('/'),caminho.length()); 
          caminho.remove(caminho.lastIndexOf('/')+1,caminho.length()); 
        }
      }
      else
        caminho = caminho+texto2+"/";
    }
    else if(texto1.equals("mkdir"))
      createDir(SD, caminho + texto2); 
    else if(texto1.equals("rmdir"))
      removeDir(SD, caminho + texto2); 
    else if(texto1.equals("rmfile"))
      deleteFile(SD, caminho + texto2);
    else if(texto1.equals("space"))
      printSpace();
    else if(texto1.equals("read"))
      readFile(SD, caminho + texto2);
      
    //Serial.print(caminho + ": ");  
}

void SerialConfig(String texto1, String nome){

    //String texto1 = //Serial.readString();
    String texto2 = texto1;
    int index = texto1.indexOf(' ');
    
    if(!(index == -1)){
      texto2.remove(0,index+1);
      texto2.remove(texto2.indexOf('\n'),1);
    }
    else{
      index = texto1.indexOf('\n');
      texto2.remove(0,texto1.length());
    }

    texto1.remove(index,texto1.length());
    
    //Serial.print(texto1);
    //Serial.print(" ");
    //Serial.println(texto2);
  
    if(texto1.equals("write")){
      //Serial.println("O que deseja escrever em " + texto2);
      writeFile(SD, caminho +texto2,nome);
    }
    else if(texto1.equals("rnfile")){
      //Serial.println("Qual novo nome de " + texto2);
      renameFile(SD, caminho + texto2,caminho + nome);
    }

    else if(texto1.equals("append")){
      //Serial.println("O que deseja adicionar em " + texto2);
      appendFile(SD, caminho +texto2,nome);
    }
    //Serial.print(caminho + ": ");  
}



void SerialConfig(File file, String texto1, char nome){
    String texto2 = texto1;
    int index = texto1.indexOf(' ');
    
    if(!(index == -1)){
      texto2.remove(0,index+1);
      texto2.remove(texto2.indexOf('\n'),1);
    }
    else{
      index = texto1.indexOf('\n');
      texto2.remove(0,texto1.length());
    }

    texto1.remove(index,texto1.length());
    
    if(texto1.equals("append")){
      appendFile(SD, file, caminho+texto2,nome);
    }
}
