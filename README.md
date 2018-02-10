Docker Images of University of Waterloo Linux Servers
===

> ...because sometimes you want to finish your CS assignments on your own computer

Docker image that replicates University of Waterloo Linux server build environment.
- `full` image includes 97.79% of the `apt-get` packages on UW servers.
- `thin` image includes 32.32% of the `apt-get` packages on UW servers, not including packages likely unnecessary to use as a build / compile / run container.
- Near identical build environment image allows for less discrepancy between your local work environment and the server test environment.


Quick Start
---

1. [Install Docker](https://docs.docker.com/install/)
2. Pull latest image 
	- `$ docker pull andrewparadi/uwaterloo:latest`
3. Mount your assignment code and run the image
	- `$ docker run -it -v {local dir}:/src --entrypoint /bin/bash -w /src andrewparadi/uwaterloo:latest`

Images
---
```
$ docker pull andrewparadi/uwaterloo:{TAG}
$ docker run -it -v {local dir}:/src --entrypoint /bin/bash -w /src andrewparadi/uwaterloo:{TAG}
```

| Tags | Collection | # Packages | Image Size | Description |
|---|---|---|---|---|
|`latest`|[INSTALL.apps](https://github.com/andrewparadi/docker-uwaterloo/tree/master/collections/INSTALL.apps)|1366|11 GB| default recommended, equivalent to `thin`|
|`thin`|[INSTALL.apps](https://github.com/andrewparadi/docker-uwaterloo/tree/master/collections/INSTALL.apps)|1366|11 GB| strips out GUI apps, fonts, latex, windowing utilities... for smaller image size |
|`full`|[PASS.apps](https://github.com/andrewparadi/docker-uwaterloo/tree/master/collections/PASS.apps)|4133|16 GB| all packages on UW Linux server that successfully install in Docker |
|`gcc`|[GCC.apps](https://github.com/andrewparadi/docker-uwaterloo/tree/master/collections/GCC.apps)|4|350 MB| Super thin image for compiling C/C++ |


Collections
---
Lists of packages on UW Linux servers used to build Dockerfiles for the above tagged images.

| Collection | Parent Collection | # Packages | Updated | Description |
|---|---|---|---|---|
|[ALL.apps](https://github.com/andrewparadi/docker-uwaterloo/tree/master/collections/ALL.apps)| | 4226 | Feb 13, 2018 | raw output from `apt-get list --installed` on UW Linux servers |
|[PASS.apps](https://github.com/andrewparadi/docker-uwaterloo/tree/master/collections/PASS.apps)|[ALL.apps](https://github.com/andrewparadi/docker-uwaterloo/tree/master/collections/ALL.apps)| 4133 | Feb 16, 2018 | UW packages that succesfully install in the `full` Docker image |
|[FAIL.apps](https://github.com/andrewparadi/docker-uwaterloo/tree/master/collections/FAIL.apps)| [ALL.apps](https://github.com/andrewparadi/docker-uwaterloo/tree/master/collections/ALL.apps)| 93 | Feb 16, 2018 |  UW packages that fail install in the `full` Docker image |
|[INSTALL.apps](https://github.com/andrewparadi/docker-uwaterloo/tree/master/collections/INSTALL.apps)|[PASS.apps](https://github.com/andrewparadi/docker-uwaterloo/tree/master/collections/PASS.apps)| 1366 | Feb 16, 2018| Thin build environment. Packages that are not in [IGNORE.apps](https://github.com/andrewparadi/docker-uwaterloo/tree/master/collections/IGNORE.apps) |
|[IGNORE.apps](https://github.com/andrewparadi/docker-uwaterloo/tree/master/collections/IGNORE.apps) | [PASS.apps](https://github.com/andrewparadi/docker-uwaterloo/tree/master/collections/PASS.apps)| 2767 | Feb 16, 2018 | Packages ignored to minimize image size |


Build Images Yourself
---
1. Derive your own ALL.apps packages list on UW Linux server 
	- `$ apt-get list --installed > ALL.apps`
2. Clone this repo
3. In the repo, create derivative collections and generate all Dockerfiles
	- `$ make build_file`
4. Build a specific image by tag (this command includes `build_file`)
	- `$ make build TAG={tag}`
5. Run including your local code directory
	- `$ docker run -it -v {local dir}:/src --entrypoint /bin/bash -w /src andrewparadi/uwaterloo:{tag}`

Contributions
---
**Add an issue**: If your build requirements that you use on UW Linux aren't in this Docker image yet, please add an issue.

**Add a single package**: If you're simply adding an apt-get package, use the following steps.

1. Run the current image that you want to add a package to
	- `$ docker run -it -v {local dir}:/src --entrypoint /bin/bash -w /src andrewparadi/uwaterloo:{tag}`
2. In the Docker container, test that the new package installs
	- `$ apt-get install {new package}`
3. If it installs, then add it to `ALL.apps`
4. Following the GitHub Flow Guidelines below, submit a Pull Request

Note: You **do not have to** build the image locally prior to Pull Request. `full` and `thin` tags take ~8-17 hours to build but [Docker Hub](https://hub.docker.com/r/andrewparadi/uwaterloo/) will automatically rebuild when your code is committed. Any failures in that process can be rolled back at that point.

**Contribute a new image:** If there's a class specific stack that you'd like to add, follow the contribution guidelines before and do the following steps as well to create a new tagged image.

1. Add a new collection of packages derived from a parent one in [build_dockerfile.sh](https://github.com/andrewparadi/docker-uwaterloo/tree/master/build_dockerfile.sh)
2. Add to list of `IMAGE`s in 2 for loops that create image folder, and generate Dockerfiles in [build_dockerfile.sh](https://github.com/andrewparadi/docker-uwaterloo/tree/master/build_dockerfile.sh)
3. Add new rows to [README.md](https://github.com/andrewparadi/docker-uwaterloo/tree/master/README.md) Images and Collections tables
4. Test building your new tagged image with `$ make build TAG={tag}`
5. When your code is merged in, a new trigger will be added to [Docker Hub](https://hub.docker.com/r/andrewparadi/uwaterloo/) to enable automatic builds for your new image

**GitHub Flow Guidelines:** Any help to fix bugs or keep packages up to date is appreciated. Please follow the [GitHub Flow](https://guides.github.com/introduction/flow/) approach to team development:

1. Fork this repo to your personal GitHub account
2. Create a feature branch based on the latest version of `Master`
3. Commit your changes
4. Rebase your commits into a single commit with `[CLOSES #{}]` as the start of the commit message if it closes a specific issue 
    - Example commit message: `[CLOSES #14] Add package zsh-autocomplete`
5. Create a Pull Request into Master

Other
---

- Released under GNU GPLv3 Licence.
- [Docker Hub](https://hub.docker.com/r/andrewparadi/uwaterloo/)
- [Source Code](https://github.com/andrewparadi/docker-uwaterloo)
- [Andrew Paradi](https://www.andrewparadi.com)
