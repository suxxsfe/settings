#include<stdlib.h>
#include<stdio.h>
int readFile(const char *f);

inline int readFile(const char *f){
	FILE *fp=fopen(f,"r");
	if(fp==NULL){
		system("xrandr --output DVI-D-1 --brightness 1");
		return 100;
	}

	int ret=0;
	fscanf(fp,"%d",&ret);
	
	if(ret>100){
		ret=100;
	}
	return ret;
}
int main(int argc,char **argv){
	if(argc>2){
		return 1;
	}
	if(argc==1||
		(argv[1][0]!='+'&&argv[1][0]!='-'&&(argv[1][0]<'0'||argv[1][0]>'9'))){
		printf("%d\n",readFile(".backlight"));
		return 0;
	}

	int backlight;
	if(argv[1][0]=='+'){
		backlight=readFile(".backlight");
		backlight+=atoi(argv[1]+1);
	}
	else if(argv[1][0]=='-'){
		backlight=readFile(".backlight");
		backlight-=atoi(argv[1]+1);
	}
	else{
		backlight=atoi(argv[1]);
	}
	if(backlight<0) backlight=0;
	if(backlight>100) backlight=100;

	static char cmd[1024];

	sprintf(cmd,"xrandr --output DVI-D-1 --brightness %.2lf",backlight/100.0);
	system(cmd);
	sprintf(cmd,"echo %d > .backlight",backlight);
	system(cmd);
	return 0;
}
