<img src="https://github.com/Solcast/Solcast.jl/blob/main/docs/src/assets/logo.png?raw=true" width="100" align="right">

# Solcast API Julia SDK

`<em>`simple Julia SDK to access the Solcast API`</em>`

---

**Documentation**: `<a href="https://solcast.github.io/Solcast.jl/" target="_blank">`https://solcast.github.io/Solcast.jl/ `</a>`

## Install

```commandline
TODO: Deploy on julia registry
using Pkg; Pkg.add("Solcast")
```

or from source:

```commandline
git clone https://github.com/Solcast/Solcast.jl.git
cd Solcast.jl
```

Go to Julia REPL and open package management mode using `]`, to install the package:

```
dev .
```

OR

```
dev `/absolute-path/to/the/repo`
```

To check if the package has been installed in the local Julia registry, go back to Julia prompt and run the following snippet:

```
using Solcast
Solcast.version
```

The version should print on the command line.

## Basic Usage

```julia
using Solcast: Historic

res = Historic.radiation_and_weather(-33.856784, 151.215297, "2022-10-25T14:45:00.000Z"; output_parameters=["air_temp"], duration="P1D")

df = Historic.to_dataframe(res)
```

Don't forget to set your [account Api Key](https://toolkit.solcast.com.au/register) with:
``export SOLCAST_API_KEY={your commercial api_key}``

---

## Contributing

Tests are run against the Solcast API, you will need a key to run them.
They are executed on `unmetered locations` and as such won't consume your credits.

To run the tests, run Julia REPL inside the project repo:

```
julia --project=.
```

Open package management mode using `]` and run the tests using `test` command inside the REPL Pkg prompt.
