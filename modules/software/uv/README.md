# UV tools

`default.nix` configures UV itself. Each file in `tools/` declares one PyPI
package installed with `uv tool install` through `programs.uv.tool.packages`.

Add a tool as `tools/<package-name>.nix` using the package name as the entry in
`programs.uv.tool.packages`. `import-tree` imports these files automatically.
