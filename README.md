# README

Command-line program to submit arbitrary commands to the Slurm workload manager using a shell one-liner, like so:

```
squick -J my_new_job -C 'echo "Hello world"' 

squick -J my_second_job -C "Rscript my/rscript.R" 
```

`squick` customises a template file containing slurm boilerplate with the specified command-line options then runs `sbatch` on the modified copy. There may still be some bugs in the script, especially with the `sed` invocation, so use with caution. 

The full list of command-line options for `squick` can be found in the `usage` message at the top of `squick.sh`.
