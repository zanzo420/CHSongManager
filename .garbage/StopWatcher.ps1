 
#To stop monitoring the text files in your specified directory run the script bellow.
if($RenamedEvent) {$RenamedEvent.Dispose()}
if($DeletedEvent) {$DeletedEvent.Dispose()}
if($CreatedEvent) {$CreatedEvent.Dispose()}
if($ChangedEvent) {$ChangedEvent.Dispose()}

<#
     c# style go add delegates to your filewatcher
     fileWatcher.Changed += new FileSystemEventHandler(Wathcer_Changed);
     fileWatcher.Created += new FileSystemEventHandler(Wathcer_Changed); 
     fileWatcher.Deleted += new FileSystemEventHandler(Wathcer_Changed);

     static void Wathcer_Changed(object sender, FileSystemEventArgs e)
     {
          Console.WriteLine("Change Type = {0}, Path = {1}", e.ChangeType, e.FullPath);
     }
#>