# stack.io on dotCloud

This is a preset sample project ready to be deployed on dotCloud for applications using the [stack.io](http://github.com/dotcloud/stack.io) framework.

## Instructions

1. Clone this repository
2. Create dotCloud app

* CLI 0.4

         cd stack.io-on-dotcloud/
         dotcloud create mystackioapp
         dotcloud push mystackioapp .
 
* CLI 0.9+

        cd stack.io-on-dotcloud/
        dotcloud create mystackioapp
        dotcloud push -A mystackioapp .

  Patience! The first push takes a while because we're compiling and installing node.js on your container. Subsequent pushes will be much shorter.

3. Set up your application in the `project` subfolder - You're all set!

## FAQ

### How do I use a different node.js/stack.io version?

Modify the `stackio_version` and `node_version` variables in the `build.sh` script.

### How do I use a different subfolder name for my project?

Modify the `project_dir` variable in the `build.sh` script.

### How do I set up additional stack.io services?

Add an entry in the `processes` dictionary in your `dotcloud.yml` file. Use the `start.sh` script to pass the required `LD_LIBRARY_PATH` configuration to the node script indicated as argument.