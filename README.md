# LilyGen

General lilypond sheet music template for composers.

## Install

Download or clone the project,
and add the `bin` directory to `PATH`.

Install with any shell:

```sh
installDir="${HOME}/opt/lilygen"
mkdir -p "$installDir"
git clone https://github.com/davidsusu/lilygen.git "$installDir"
echo '' >> "${HOME}/.profile"
echo '# LilyGen' >> "${HOME}/.profile"
echo 'export PATH="${PATH}:'"$installDir"'"' >> "${HOME}/.profile"
source "${HOME}/.profile"
```

Choose any `installDir` you like.

It's better to not edit the `.profile` file,
most shells provide more sophisticated methods
For example, with bash:

```bash
installDir=~/opt/lilygen
mkdir -p "$installDir"
git clone https://github.com/davidsusu/lilygen.git "$installDir"
echo 'export PATH="${PATH}:'"$installDir"'"' > ~/.bashrc.d/lilygen.bashrc
. ~/.profile
```

## Usage

```
lilygen [<target-directory]
```

Default target directory is the current directory (`.`).



Currently I recommend to manually clone or download the the `template` directory.
(Installer script is in progress.)
