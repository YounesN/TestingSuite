# Explanation

This suite will check one of GOMC branches and makes sure that OpenMP, and CUDA matches the serial version

IT DOES NOT CHECK AGAINST MASTER!!!

We only need three files, job script folder, githubmaster.sh, and compare.sh.
Delete the rest and run ./githubmaster.sh, then you can double check compare.sh to see if everything matches.

In job_script folder the qsub files reside.
In case of grid upgrades edit these files to update modules
