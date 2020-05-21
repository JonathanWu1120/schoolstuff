#include <stdio.h>

long minVal(char type,int isSigned);
long maxVal(char type,int isSigned);

int main(int argc, char **argv) {
	printf("%20ld <= %15s <= %20ld\n",minVal('c',1),"Signed Char",maxVal('c',1));
	printf("%20lu <= %15s <= %20lu\n",minVal('c',0),"Unsigned Char",maxVal('c',0));
	printf("%20ld <= %15s <= %20ld\n",minVal('s',1),"Signed Short",maxVal('s',1));
	printf("%20lu <= %15s <= %20lu\n",minVal('s',0),"Unsigned Short",maxVal('s',0));
	printf("%20ld <= %15s <= %20ld\n",minVal('i',1),"Signed Int",maxVal('i',1));
	printf("%20lu <= %15s <= %20lu\n",minVal('i',0),"Unsigned Int",maxVal('i',0));
	printf("%20ld <= %15s <= %20ld\n",minVal('l',1),"Signed Long",maxVal('l',1));
	printf("%20lu <= %15s <= %20lu\n",minVal('l',0),"Unsigned Long",maxVal('l',0));
	return 0;
}

long minVal(char type, int isSigned) {
	if (isSigned) {
		char ics=0;
		short iss = 0;
		int iis = 0;
		long ils = 0;
		switch(type) {
			case 'c':
				while((char)(ics-1) < ics) {
					ics=ics-1;
				}
				return ics;
			case 'i':
				while((int)(iis-1) < iis){
					iis = iis - 1;
				}
				return iis;
			case 's':
				while((short)(iss-1) < iss){
					iss = iss - 1;
				}
				return iss;
			case 'l':
				while((long)(ils-1) < ils){
					if(ils != 0){
						ils = ils * 2;
					}else{
						ils -= 1;
					}
				}
				return ils;
			default:
				printf("Signed type of %c not supported\n",type);
		}
	} else {
		unsigned char icu=0;
		unsigned short isu = 0;
		unsigned int iiu = 0;
		unsigned long ilu = 0;
		switch(type) {
			case 'c':
				while((unsigned char)(icu-1) < icu) {
					icu=icu-1;
				}
				return icu;
			case 'i':
				while((unsigned int)(iiu-1) < iiu) {
					iiu=iiu-1;
				}
				return iiu;
			case 's':
				while((unsigned short)(isu-1) < isu) {
					isu=isu-1;
				}
				return icu;
			case 'l':
				while((unsigned long)(ilu-1) < ilu){
					ilu = ilu - 1;
				}
				return ilu;
			default:
				printf("Unsigned type of %c not supported\n",type);
		}
	}
	return 0;
}

long maxVal(char type, int isSigned) {
	if (isSigned) {
		char ics=0;
		short iss = 0;
		int iis = 0;
		long ils = 0;
		switch(type) {
			case 'c':
				while((char)(ics+1) > ics) {
					ics=ics+1;
				}
				return ics;
			case 'i':
				while((int)(iis+1) > iis){
					iis =iis + 1;
					//printf("%d b \n",iis);
				}
				return iis;
			case 's':
				while((short)(iss+1) > iss){
					iss =iss + 1;
				}
				return iss;
			case 'l':
				while((long)(ils+1) > ils){
					long prev = ils;
					if(ils != 0){
						ils = ils*2;
					}else{
						ils++;
					}
					if(ils < prev){
						ils -= 1;	
					}
				}
				return ils;
			default:
				printf("Signed type of %c not supported\n",type);
		}
	} else {
		unsigned char icu=0;
		unsigned short isu = 0;
		unsigned int iiu = 0;
		unsigned long ilu = 0;
		switch(type) {
			case 'c':
				while((unsigned char)(icu+1) > icu) {
					icu=icu+1;
				}
				return icu;
			case 'i':
				while((unsigned int)(iiu+1) > iiu) {
					iiu+=1;
					//printf("%d a ",iiu);
				}
				return iiu;
			case 's':
				while((unsigned short)(isu+1) > isu) {
					isu+=1;
				}
				return isu;
			case 'l':
				while((unsigned long)(ilu+1)>ilu){
					unsigned long prev = ilu;
					if(ilu > 1){
						ilu = ilu * 2;
					}else{
						ilu ++;
					}if(ilu < prev){
						ilu -= 1;
					}
				}
				return ilu;
			default:
				printf("Unsigned type of %c not supported\n",type);
		}
	}
	return 0;
}
