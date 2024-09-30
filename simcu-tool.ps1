function proxy {
    $env:http_proxy="http://100.100.13.14:8118"
    $env:https_proxy="http://100.100.13.14:8118"
    $env:HTTP_PROXY="http://100.100.13.14:8118"
    $env:HTTPS_PROXY="http://100.100.13.14:8118"
  }
  
  function unproxy {
    Remove-Item Env:http_proxy
    Remove-Item Env:https_proxy
    Remove-Item Env:HTTP_PROXY
    Remove-Item Env:HTTPS_PROXY
  }
  
  function env {
    Get-ChildItem Env:
  }
  
  function concatvs {
      $targetPath = "C:\Users\xrain\Downloads\NetVideos"
      Rename-Item -Path .\1.mp4 -NewName 01.mp4
      Rename-Item -Path .\2.mp4 -NewName 02.mp4
      Rename-Item -Path .\3.mp4 -NewName 03.mp4
      Rename-Item -Path .\4.mp4 -NewName 04.mp4
      Rename-Item -Path .\5.mp4 -NewName 05.mp4
      Rename-Item -Path .\6.mp4 -NewName 06.mp4
      Rename-Item -Path .\7.mp4 -NewName 07.mp4
      Rename-Item -Path .\8.mp4 -NewName 08.mp4
      Rename-Item -Path .\9.mp4 -NewName 09.mp4
  
      $currentDirectory = Split-Path -Path (Get-Location) -Leaf
      New-Item -Path "$targetPath\$currentDirectory" -ItemType Directory
      New-Item -Path "$targetPath\$currentDirectory\temp" -ItemType Directory
  
      Copy-Item -Path .\0.jpg -Destination "$targetPath\$currentDirectory\$currentDirectory.jpg"
      Copy-Item -Path .\0.png -Destination "$targetPath\$currentDirectory\$currentDirectory.png"
  
      Get-ChildItem -Path *.mp4 | ForEach-Object {
          & "ffmpeg.exe" -i $_ -vf "fps=30,scale=1080:1920" -b:v 1500k "$targetPath\$currentDirectory\temp\$($_.BaseName)_converted.mp4"
      }
  
      Get-ChildItem -Path "$targetPath\$currentDirectory\temp\*_converted.mp4" | ForEach-Object {
          Add-Content -Path "$targetPath\$currentDirectory\filelist.txt" -Value "file '$($_.FullName)'"
      }
  
      & "ffmpeg.exe" -f concat -safe 0 -i "$targetPath\$currentDirectory\filelist.txt" -c copy "$targetPath\$currentDirectory\$currentDirectory.mp4"
  
      Remove-Item -Path "$targetPath\$currentDirectory\temp" -Recurse
      Remove-Item -Path "$targetPath\$currentDirectory\filelist.txt"
  }
  
  function ssh-copy-id {
      param(
          [Parameter(Mandatory = $true)]
          [string]$RemoteHost
      )
  
      # 默认公钥路径，你可以根据需要修改
      $PublicKeyPath = "$HOME\.ssh\id_rsa.pub"
  
      # 读取公钥内容
      $publicKey = Get-Content -Path $PublicKeyPath
  
      # 创建 .ssh 目录和 authorized_keys 文件（如果不存在）
      $sshCommand ="mkdir -p ~/.ssh && chmod 700 ~/.ssh && touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && "
  
      # 将公钥添加到 authorized_keys 文件中
      $sshCommand += "echo `'$publicKey`' >> ~/.ssh/authorized_keys"
  
      # 连接到远程主机并执行命令
      ssh $RemoteHost $sshCommand
  }