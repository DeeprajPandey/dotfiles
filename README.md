# ~/.deepraj 🖥️

Welcome to the backbone of my MacOS setup. This repository houses my personally curated dotfiles, optimized for MacOS. The setup is managed using [Dotbot](https://github.com/anishathalye/dotbot), which makes it easy to set up a new system or keep existing setups in sync.

## Getting Started

### Prerequisites

- A MacOS system
- A working internet connection

### Brew the Essentials

Whenever I'm setting up a new MacOS environment, I typically start by installing a few essential tools and apps using [Homebrew](https://brew.sh/). To streamline this initial setup, I've included the `setup.sh` script in this repository. You have two options:

1. Download [the script](https://raw.githubusercontent.com/DeeprajPandey/dotfiles/HEAD/setup.sh) directly from the repository and run it.
2. Install `git` first, then clone this repository to access the script along with all other dotfiles.

Once you have a copy, make the script executable and run it:

```sh
chmod +x setup.sh
./setup.sh
```

## Installation

With the groundwork done, here's how to get the dotfiles up and running:

1. **Clone this repository**:
   ```sh
   git clone https://github.com/DeeprajPandey/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Run the install script**:
   ```sh
   ./install
   ```

   The above command will symlink the dotfiles and run any setup scripts to ensure your environment is correctly set up.

## Support & Contributions

If you run into issues or have any questions, please feel free to [open an issue](https://github.com/DeeprajPandey/dotfiles/issues).

While I'll strive to respond, do note that this is not an actively maintained project. These dotfiles represent configurations that are tailored to my preferences and may not suit everyone's needs.

Contributions are always welcome! Please create a pull request with your changes or improvements.

## License

This project is licensed under the GNU GPL v3.0 License. See the [LICENSE.md](LICENSE.md) file for details.
