## To reproduce
```
nix develop --command bash -c 'mkdir build && cd build && cmake ..'
```

## Correct behavior
```
nix develop .#fixed --command bash -c 'mkdir build && cd build && cmake ..'
```
