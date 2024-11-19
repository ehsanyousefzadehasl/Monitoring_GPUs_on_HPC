# How to connect to ITU's HPC cluster
To connect to ITU's HPC cluster, you need your ITU username and SSH access:


```bash
ssh <your_username>@hpc.itu.dk
```

Use your university email password to log in, the same as for other ITU systems.

The ITU HPC cluster uses SLURM as its scheduler/resource manager. SLURM handles tasks submitted by users and allocates the specified resources based on the task description. To execute tasks on the cluster, you must create a task script like the following example:

```bash
#!/bin/bash

#SBATCH --job-name=cuda_test_job_name      # Job name
#SBATCH --output=cuda_test_output_name     # output file name
#SBATCH --cpus-per-task=1                  # Schedule 8 cores (includes hyperthreading)
#SBATCH --gres=gpu                         # Schedule a GPU, it can be on 2 gpus like gpu:2
#SBATCH --time=00:05:00                    # Run time (hh:mm:ss)
#SBATCH --partition=scavenge               # Run on any permitted queue that has availability
#SBATCH --exclusive			   # Exclusive access to the server

module load CUDA/12.1.1

nvcc test_cuda.cu -o test_cuda

dcgmi dmon -e 155,156,200,201,203,204,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012 > dcgmi-log.out &

nvidia-smi --query-gpu=gpu_name,pstate,timestamp,utilization.gpu,utilization.memory,memory.total,memory.used --format=csv -l 1 -f nvidia-smi-log.out &

./test_cuda
```

## Notes:

1. You do not have admin access on the cluster, so you cannot install software yourself.
2. Use the module system to load software packages installed by the admins.

For example, to load CUDA:

```bash
module CUDA/12.1.1 
```

This command loads the CUDA environment, including the NVCC compiler needed to compile CUDA programs.

To view all available modules on the cluster:

```bash
module avail
```

## Monitoring CPUs and GPUs
To monitor various hardware metrics during program execution, one can use tools such as 'top' for CPUs and 'nvidia-smi' and dcgmi' for GPUs, which you can also see in the example above.

## To execute the job

```bash
sbatch myjobv2.job
```

## To monitor the job status

```bash
squeue
```

```bash
squeue -u <username>
```

## After Execution
Once the task is complete, you can check the GPU metrics in the log files:
- dcgmi-log.out: Contains detailed metrics captured by dcgmi.
- nvidia-smi-log.out: Logs GPU state and usage metrics as specified in the query.
