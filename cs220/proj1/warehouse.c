#include "order.h"
#include "bench.h"
#include <stdio.h>

int main(int argc, char **argv) {
	if (argc<2) {
		printf("Please invoke as %s <order_file>\n",argv[0]);
		return 1;
	}
	if (!openOrder(argv[1])) {
		return 1;
	}
	int boxes[100] = {0};
	do {
		int pn=nextPartNumber();
		int bin=pn/10;
		boxes[bin]++;
		/* ----------------------------------------------------------------------
		The following code does the job, but very inefficiently.
		Replace this code with your own code to handle the
		slots on the workbench more intelligently (and earn
		more profit.)
		-----------------------------------------------------------------------*/
		int full_bench = 0;
		if(binInSlot(0) != -1 && binInSlot(1) != -1 &&binInSlot(2) != -1 &&binInSlot(3) != -1 &&binInSlot(4) != -1){
			full_bench = 1;
		}
		int bin_in_bench = 0;
		if(binInSlot(0) == bin || binInSlot(1) == bin || binInSlot(2) == bin || binInSlot(3) == bin || binInSlot(4) == bin){
			bin_in_bench = 1;
		}
		if(!bin_in_bench){
			if(!full_bench){
				if(binInSlot(0) == -1 && !bin_in_bench){
					fetchBin(bin,0);
				}else if(binInSlot(1) == -1 && !bin_in_bench){
					fetchBin(bin,1);
				}else if(binInSlot(2) == -1 && !bin_in_bench){
					fetchBin(bin,2);
				}else if(binInSlot(3) == -1 && !bin_in_bench){
					fetchBin(bin,3);
				}else if(binInSlot(4) == -1 && !bin_in_bench){
					fetchBin(bin,4);
				}
			}else{
				int a = boxes[binInSlot(0)];
				int b = boxes[binInSlot(1)];
				int c = boxes[binInSlot(2)];
				int d = boxes[binInSlot(3)];
				int e = boxes[binInSlot(4)];
				int bench[5] = {a,b,c,d,e};
				int small = e;
				int index = 4;
				for(int i = 0;i<5;i++){
					if(bench[i] < small){
						small = bench[i];
						index = i;
					}
				}
				fetchBin(bin,index);
			}
		}

	} while(fetchNextPart());
	closeOrder();
	return 0;
}
