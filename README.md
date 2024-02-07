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
lilygen [<target-directory> [<preset>]]
```

The default target directory is the current directory (`.`).
The default preset is an example ensemble (`default`).

## Template structure

You can specify metadata, instrument definitions and music data.

Each instrument/staff has its own tag.
Music can be written from bar to bar,
in each bar the related slice of the staff is marked with its tag.

Each staff can be generated as a whole by filtering for its tag.
This final assembly is automatic, included in the template.

Because the bar content is integrated,
inserting, deleting or moving bars is much more easier
than when the staff contents are kept separate.
So it can be used directly for composing,
but it's also fits well with version handling.
