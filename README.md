SlicerExecutionModel
====================

[![CI](https://github.com/Slicer/SlicerExecutionModel/actions/workflows/ci.yml/badge.svg)](https://github.com/Slicer/SlicerExecutionModel/actions/workflows/ci.yml)

Overview
--------

The SlicerExecutionModel is a CMake-based project providing macros and associated tools
allowing to easily build Slicer CLI (Command line module).

It is designed to improve the acceptance and productivity of Slicer application developers.
The Execution Model provides a simple mechanism for incorporating command line programs as Slicer modules.
These command line modules are self-describing, emitting an XML description of its command line arguments.
Slicer uses this XML description to construct a GUI for the module.

SlicerExecutionModel is documented here:

https://www.slicer.org/wiki/Documentation/Nightly/Developers/SlicerExecutionModel.

Contributing
------------

There are many ways to contribute to SlicerExecutionModel, with varying levels of effort. Do try to
look through the documentation first if something is unclear, and let us know how we can
do better.

- Ask a question on the [Slicer forum][forum]
- Submit a feature request or bug, or add to the discussion on the [issue tracker][is]
- Submit a [Pull Request][pr] to improve the SlicerExecutionModel or its documentation

We encourage a range of contributions, from patches that include passing tests and
documentation, all the way down to half-baked ideas that launch discussions.


### How to submit a PR

If you are new to SlicerExecutionModel development and you don't have push access to the
SlicerExecutionModel repository, here are the steps:

1. [Fork and clone](https://help.github.com/articles/fork-a-repo/) the repository.
2. Create a branch.
3. [Push](https://help.github.com/articles/pushing-to-a-remote/) the branch to your GitHub fork.
4. Create a [Pull Request][pr].

This corresponds to the ``Fork & Pull Model`` mentioned in the
[GitHub flow](https://guides.github.com/introduction/flow/index.html) guides.

If you have push access to SlicerExecutionModel repository, you could simply push your branch
into the main repository and create a [Pull Request][pr]. This
corresponds to the ``Shared Repository Model`` and will facilitate other developers to checkout your
topic without having to [configure a remote](https://help.github.com/articles/configuring-a-remote-for-a-fork/).
It will also simplify the workflow when you are *co-developing* a branch.

When submitting a PR, make sure to add a ``Cc: @slicer/slicerexecutionmodel`` comment to notify SlicerExecutionModel
developers of your awesome contributions. Based on the
comments posted by the reviewers, you may have to revisit your patches.


### Automatic testing of pull requests

When you submit a PR to the SlicerExecutionModel repo, GitHub Actions builds and
tests the head of the branch, and again for every new commit pushed to it. The
status of each job is displayed on the PR page in GitHub.

The jobs are defined in [.github/workflows/ci.yml](.github/workflows/ci.yml).
Each job builds the ITK modules SlicerExecutionModel needs (ITKCommon,
ITKIOXML, and ITKExpat) from a pinned ITK tag, caches that build, then
configures, builds, and tests SlicerExecutionModel with CMake and CTest. No
custom Docker images are involved, so the same steps work on a developer
machine.

### Testing environments

The workflow matrix covers Linux, macOS, and Windows, more than one ITK
version, and a Linux build with JsonCpp and ParameterSerializer enabled. To
add or update an environment, edit the `matrix` in
[.github/workflows/ci.yml](.github/workflows/ci.yml) and open a PR. Changing
the `itk` value of an entry changes its cache key, so the new ITK is built on
the first run.

### How to integrate a PR

Getting your contributions integrated is relatively straightforward, here is the checklist:

- All tests pass

- Consensus is reached. This requires that a reviewer adds an "approved" review via GitHub with no
  changes requested, and a reasonable amount of time passed without anyone objecting.

Next, there are two scenarios:

- You do NOT have push access: A SlicerExecutionModel core developer will integrate your PR.
- You have push access: Simply click on the "Merge pull request" button.

Then, click on the "Delete branch" button that appears afterward.

License
-------

See http://www.slicer.org/copyright/copyright.txt for details.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


[fk]: http://help.github.com/forking/
[is]: http://github.com/Slicer/SlicerExecutionModel/issues
[pr]: http://github.com/Slicer/SlicerExecutionModel/pulls
[forum]: https://discourse.slicer.org/

