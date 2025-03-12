# ListFireTVs

## 📌 About the Project

The **ListFireTVs** is a PowerShell script designed to list Fire TV devices connected to the network. It quickly identifies Fire TV devices and can be useful for automation or troubleshooting.

## 🔍 Alternative Discovery Methods  

Fire TVs typically announce their services on the network via mDNS (Bonjour). If you're interested in other ways to discover Fire TVs on your network, you can use the following methods:  

- **On Windows (using dns-sd.exe from Bonjour)**  
  You can search for devices advertising `_amzn-wplay._tcp.local` on [Windows](https://stackoverflow.com/questions/54216363/how-to-install-the-dns-sd-command-line-test-tool-on-windows-or-linux) with:
  ```powershell
  dns-sd -B _amzn-wplay._tcp

- **On Linux/macOS (using avahi-browse)**
  While this script is designed for Windows, you can also discover Fire TVs on [Linux/macOS](https://gist.github.com/davisford/5984768) with:
  ```sh
  avahi-browse -a | grep "Fire"

## 🚀 Features

- Discovers Fire TV devices on the local network.
- Displays useful information about the found devices.

## 🛠️ Requirements

Before getting started, make sure you have the following requirements installed:

- Windows with PowerShell 5.1 or later
- [Bonjour](https://developer.apple.com/bonjour/) [SDK v3.0](https://download.developer.apple.com/Developer_Tools/bonjour_sdk_for_windows_v3.0/bonjoursdksetup.exe)

## 📦 Installation

1. Clone this repository:
   ```powershell
   git clone https://github.com/dfmuniz74/ListFireTVs.git
   cd ListFireTVs
   ```

## ▶️ How to Use

Run the script with the following command:

```powershell
.\ListFireTVs.ps1
```

## 🤝 Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a branch for your feature: `git checkout -b my-feature`
3. Commit your changes: `git commit -m 'Add new feature'`
4. Push to the remote repository: `git push origin my-feature`
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Created by [dfmuniz74](https://github.com/dfmuniz74) 🚀

