# cocoapods-use-latest-tag

cocoapods-use-latest-tag will one key to change Podfile, check and use the latest tag for this Pod. It will save your time when you want to change every Pod to use the latest tag for release your main project. 

## Installation

    $ gem install cocoapods-use-latest-tag

## Usage

`pod use-latest-tag` will display a list of Pods that changed by this command.

    $ pod use-latest-tag
    ~KNConvergeBill, ~SuiNetworking
    [!] 2 Pods has been changed to use the latest tag. Please double check the Podfile's changes.

The symbol before each Pod name indicates the status of the Pod. A `~` indicates there is newest tag can be used. Pods that don't require an update will not be listed.

Verbose mode shows a bit more detail:

    $ pod use-latest-tag --verbose
    KNConvergeBill preview_branch: master -> latest_tag: 2.0.3
    SuiNetworking preview_tag: 3.1.0 -> latest_tag: 3.1.3
    [!] 2 Pods has been changed to use the latest tag. Please double check the Podfile's changes.

If no Pods are out of date, then the output looks like:

    $ pod use-latest-tag
    The Podfile's dependencies all use latest tag.

## Exit Code

If any Pods are out of date, `pod use-latest-tag` will exit with a non-zero exit code. Otherwise it will exit with an exit code of zero.

## License

cocoapods-use-latest-tag is under the MIT license. See the [LICENSE](LICENSE) file for details.

