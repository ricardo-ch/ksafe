# ksafe

> Oops, was I still in prod?

If you have ever said or thought something like this after executing a kubectl command, you are at the right place.

Ksafe is a small shell wrapper around `kubectl` created to secure your production environment(s).
The principle is simple, if you stayed idle for too long in one of your protected environments, you will be prompted a reminder and will be asked to confirm your action.

_Disclaimer: the ksafe script is written in zsh. I do not guarantee its behaviour in standard sh / bash environments._

## Installation

1. Clone the repository to your local machine
2. Move to the cloned repository
3. If this is your first installation, execute `install.sh`.
4. If you wish to reinstall Ksafe, execute `reinstall.sh`. If you downloaded a more recent version of Ksafe, this will update the installed version.

The installed shell script and configuration file will be located at `~/.ksafe/`.

## Uninstallation

1. If you deleted the downloaded version and wish to uninstall Ksafe, re-clone the repository (will be improved).
2. Move to the cloned repository
3. Execute `unintall.sh`. Note: it will work even if the installed version is older than the downloaded uninstallation script.

## Setup

To verify that Ksafe is correctly installed, execute `ksafe` without any argument. It should prompt the `kubectl` manual.

You will find in your `.ksafe` folder a config file, containing the following values:
* KSAFE_DELAY_S: (default:300) the delay in seconds after which you will be prompted the warning
* KSAFE_DANGEROUS_CONTEXT: (default: prod) regular expression that must match the environments you wish to protect
* KSAFE_SAFE_CONTEXT: (default: dev) environment you wish to return to when you did not want to execute your command in your actual environment.
* KSAFE_PRODUCTION_TS: this variable will store the time of the last command issued in a protected environment.

## Usage

Simply call `ksafe` instead of `kubectl`. That's it.

Whenever the context you are executing the command from matches the `KSAFE_DANGEROUS_CONTEXT` regular expression, Ksafe will check if you have been idle in this context for too long, and eventually prompt a warning if this delay exceeds `KSAFE_DELAY_S`.

If you use `reset` as your first argument in a call to `ksafe`, no warning will be prompted, whatever the delay since your last command. This allows you to switch between contexts without getting the warning, or to create aliases on top of non-dangerous commands to not get the warning.

Example which will never trigger the warning:

> ksafe reset get pods

## Recommendations

To benefit from the best Ksafe experience:
1. Replace `kubectl` with `k` in all your kubectl-related aliases
2. Create an alias `k="ksafe"`. Important: if you are using a zsh theme, this alias must be declared **after** the theme selection of your `.zshrc` since most themes override this alias to `k="kubectl"`.
3. if you use aliases to switch between your contexts, write `k reset` instead of `k`. This will prevent the warning prompt on context switching.

By following this recommendation, if you wish to stop using Ksafe, you only have to change your `k` alias to `k="kubectl"`.

Example of alias set:

```
alias k="ksafe"
alias dev="k reset config use-context dev"
alias prod="k reset config use-context prod"
alias kgp="k get pods"
alias kdp="k describe pods"
alias kgn="k get nodes"
alias kdn="k describe nodes"
alias kgd="k get deployments"
alias kdd="k describe deployments"
alias kpf="k port-forward"
...
```