# BTC Address
A collection of tools for Bitcoin address generation, information retrieval, and various utilities.

## Motivation
Scripts for a detailed and accurate representation of the algorithm for generating BTC addresses using standard technologies such as bash. These scripts can run on simple offline devices to increase security.

## Shell
- [btc-address.sh](sh/btc-address.sh)
- [btc-address-min.sh](sh/btc-address-min.sh)
 
Minimal shell script that uses `openssl` to generate a Bitcoin address from an entropy input.

### Example
```
$ ./sh/btc-address.sh [ENTROPY]
```

```shell
$ ./sh/btc-address.sh
entropy:
priv: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
priv WIF: ssjWnCBs992j1CS2ryy7dTz5PNnGwbbQ2XutrPF3z93oEUdZYK5
pub: 04a34b99f22c790c4e36b2b3c2c35a36db06226e41c692fc82b8b56ac1c540c5bd5b8dec5235a0fa8722476c7709c02559e3aa73aa03918ba2d492eea75abea235
btc: 1NzEiDga54pxkKa6wDxJaSTfZoaekjkwZH
```

[![CC BY 4.0][cc-by-shield]][cc-by]

This work is licensed under a [Creative Commons Attribution 4.0 International License][cc-by].

[![CC BY 4.0][cc-by-image]][cc-by]

[cc-by]: http://creativecommons.org/licenses/by/4.0/
[cc-by-image]: https://i.creativecommons.org/l/by/4.0/88x31.png
[cc-by-shield]: https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg
