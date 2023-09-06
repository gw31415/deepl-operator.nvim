# deepl-operator.nvim

Mapping that enables to translate with `<Plug>(deepl-replace)`!

## Example

If you are using dein.vim, set up as follows:

```toml
[[plugins]]
repo = "gw31415/deepl.vim"
hook_source = "let g:deepl_authkey='XXXXXXXXX'"

[[plugins]]
repo = "gw31415/deepl-operator.nvim"
depends = ["deepl.vim"]
on_map = { nx = "dt" }
hook_source = '''
    nmap dt <Plug>(deepl-replace)
    xmap dt <Plug>(deepl-replace)
'''
```

## Related Plugins

- [gw31415/deepl.vim](https://github.com/gw31415/deepl.vim)
- [gw31415/deepl-commands.nvim](https://github.com/gw31415/deepl-commands.nvim)
