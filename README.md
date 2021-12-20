# LilyGen

General lilypond sheet music template for composers.

## Install

Download or clone the project,
and add the `bin` directory to `PATH`.

For example:

```sh
installDir=~/opt/lilygen # change as you like
mkdir -p "$installDir"
git clone https://github.com/davidsusu/lilygen.git "$installDir"
echo 'export PATH="${PATH}:'"$installDir"'"' >> ~/.profile
# or: echo 'export PATH="${PATH}:'"$installDir"'"' > ~/.bashrc.d/lilygen.bashrc
source ~/.profile
```

## Usage

```
lilygen [<target-directory]
```

Default target directory is the current directory (`>.`).



Currently I recommend to manually clone or download the the `template` directory.
(Installer script is in progress.)
