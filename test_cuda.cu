#include<iostream>
#include<cuda_runtime.h>

// kernel (function) to be executed on the GPU
__global__ void helloWorld() {
        printf("Hello from thread %d from block %d\n", threadIdx.x, blockIdx.x);
}

int main() {
        // launch the GPU kernel

        for(int i = 0; i < 100000; ++i){
            helloWorld<<<2048, 1024>>>();
        }
        
        cudaDeviceSynchronize();

        return 0;
}