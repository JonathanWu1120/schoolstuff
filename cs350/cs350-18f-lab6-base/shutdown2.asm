
_shutdown2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  delay_seconds: number of seconds delayed before shutdown.\n\
  custom_word: word to display after the dealy countdown.\n"

int 
main(int argc, char * argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
	int waitsecs = 0;
	char * msg;
	
    if (argc < 3)
   f:	83 39 02             	cmpl   $0x2,(%ecx)
{
  12:	8b 59 04             	mov    0x4(%ecx),%ebx
    if (argc < 3)
  15:	7f 17                	jg     2e <main+0x2e>
	{
        printf(1, "%s", USAGE_STR);
  17:	53                   	push   %ebx
  18:	68 7c 07 00 00       	push   $0x77c
  1d:	68 78 07 00 00       	push   $0x778
  22:	6a 01                	push   $0x1
  24:	e8 27 04 00 00       	call   450 <printf>
		exit();
  29:	e8 d4 02 00 00       	call   302 <exit>
	}
	
	waitsecs = atoi(argv[1]);
  2e:	83 ec 0c             	sub    $0xc,%esp
  31:	ff 73 04             	pushl  0x4(%ebx)
  34:	e8 57 02 00 00       	call   290 <atoi>
	msg = argv[2];
	
    shutdown(waitsecs, msg);
  39:	5a                   	pop    %edx
  3a:	59                   	pop    %ecx
  3b:	ff 73 08             	pushl  0x8(%ebx)
  3e:	50                   	push   %eax
  3f:	e8 4c 00 00 00       	call   90 <shutdown>
	
    exit(); // return 0;
  44:	e8 b9 02 00 00       	call   302 <exit>
  49:	66 90                	xchg   %ax,%ax
  4b:	66 90                	xchg   %ax,%ax
  4d:	66 90                	xchg   %ax,%ax
  4f:	90                   	nop

00000050 <my_sleep>:
void my_sleep(int secs){
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	53                   	push   %ebx
  54:	83 ec 04             	sub    $0x4,%esp
  57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	for(int i = secs; i > 0; i--){
  5a:	85 db                	test   %ebx,%ebx
  5c:	7e 26                	jle    84 <my_sleep+0x34>
  5e:	66 90                	xchg   %ax,%ax
		printf(1, "%d ",i);
  60:	83 ec 04             	sub    $0x4,%esp
  63:	53                   	push   %ebx
  64:	68 70 07 00 00       	push   $0x770
  69:	6a 01                	push   $0x1
  6b:	e8 e0 03 00 00       	call   450 <printf>
		sleep(100);
  70:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  77:	e8 16 03 00 00       	call   392 <sleep>
	for(int i = secs; i > 0; i--){
  7c:	83 c4 10             	add    $0x10,%esp
  7f:	83 eb 01             	sub    $0x1,%ebx
  82:	75 dc                	jne    60 <my_sleep+0x10>
}
  84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  87:	c9                   	leave  
  88:	c3                   	ret    
  89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000090 <shutdown>:
void shutdown(int waitsecs, char * msg) {
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	53                   	push   %ebx
  94:	83 ec 10             	sub    $0x10,%esp
  97:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	my_sleep(waitsecs);	
  9a:	ff 75 08             	pushl  0x8(%ebp)
  9d:	e8 ae ff ff ff       	call   50 <my_sleep>
	printf(1, "%s\n", msg);
  a2:	83 c4 0c             	add    $0xc,%esp
  a5:	53                   	push   %ebx
  a6:	68 74 07 00 00       	push   $0x774
  ab:	6a 01                	push   $0x1
  ad:	e8 9e 03 00 00       	call   450 <printf>
	shutdown2();
  b2:	83 c4 10             	add    $0x10,%esp
}
  b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b8:	c9                   	leave  
	shutdown2();
  b9:	e9 e4 02 00 00       	jmp    3a2 <shutdown2>
  be:	66 90                	xchg   %ax,%ax

000000c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	53                   	push   %ebx
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ca:	89 c2                	mov    %eax,%edx
  cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  d0:	83 c1 01             	add    $0x1,%ecx
  d3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  d7:	83 c2 01             	add    $0x1,%edx
  da:	84 db                	test   %bl,%bl
  dc:	88 5a ff             	mov    %bl,-0x1(%edx)
  df:	75 ef                	jne    d0 <strcpy+0x10>
    ;
  return os;
}
  e1:	5b                   	pop    %ebx
  e2:	5d                   	pop    %ebp
  e3:	c3                   	ret    
  e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	56                   	push   %esi
  f4:	53                   	push   %ebx
  f5:	8b 55 08             	mov    0x8(%ebp),%edx
  f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  fb:	0f b6 02             	movzbl (%edx),%eax
  fe:	0f b6 19             	movzbl (%ecx),%ebx
 101:	84 c0                	test   %al,%al
 103:	75 1e                	jne    123 <strcmp+0x33>
 105:	eb 29                	jmp    130 <strcmp+0x40>
 107:	89 f6                	mov    %esi,%esi
 109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 110:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 113:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 116:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
 119:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 11d:	84 c0                	test   %al,%al
 11f:	74 0f                	je     130 <strcmp+0x40>
 121:	89 f1                	mov    %esi,%ecx
 123:	38 d8                	cmp    %bl,%al
 125:	74 e9                	je     110 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 127:	29 d8                	sub    %ebx,%eax
}
 129:	5b                   	pop    %ebx
 12a:	5e                   	pop    %esi
 12b:	5d                   	pop    %ebp
 12c:	c3                   	ret    
 12d:	8d 76 00             	lea    0x0(%esi),%esi
  while(*p && *p == *q)
 130:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 132:	29 d8                	sub    %ebx,%eax
}
 134:	5b                   	pop    %ebx
 135:	5e                   	pop    %esi
 136:	5d                   	pop    %ebp
 137:	c3                   	ret    
 138:	90                   	nop
 139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000140 <strlen>:

uint
strlen(char *s)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 146:	80 39 00             	cmpb   $0x0,(%ecx)
 149:	74 12                	je     15d <strlen+0x1d>
 14b:	31 d2                	xor    %edx,%edx
 14d:	8d 76 00             	lea    0x0(%esi),%esi
 150:	83 c2 01             	add    $0x1,%edx
 153:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 157:	89 d0                	mov    %edx,%eax
 159:	75 f5                	jne    150 <strlen+0x10>
    ;
  return n;
}
 15b:	5d                   	pop    %ebp
 15c:	c3                   	ret    
  for(n = 0; s[n]; n++)
 15d:	31 c0                	xor    %eax,%eax
}
 15f:	5d                   	pop    %ebp
 160:	c3                   	ret    
 161:	eb 0d                	jmp    170 <memset>
 163:	90                   	nop
 164:	90                   	nop
 165:	90                   	nop
 166:	90                   	nop
 167:	90                   	nop
 168:	90                   	nop
 169:	90                   	nop
 16a:	90                   	nop
 16b:	90                   	nop
 16c:	90                   	nop
 16d:	90                   	nop
 16e:	90                   	nop
 16f:	90                   	nop

00000170 <memset>:

void*
memset(void *dst, int c, uint n)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	57                   	push   %edi
 174:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 177:	8b 4d 10             	mov    0x10(%ebp),%ecx
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	89 d7                	mov    %edx,%edi
 17f:	fc                   	cld    
 180:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 182:	89 d0                	mov    %edx,%eax
 184:	5f                   	pop    %edi
 185:	5d                   	pop    %ebp
 186:	c3                   	ret    
 187:	89 f6                	mov    %esi,%esi
 189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000190 <strchr>:

char*
strchr(const char *s, char c)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	53                   	push   %ebx
 194:	8b 45 08             	mov    0x8(%ebp),%eax
 197:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 19a:	0f b6 10             	movzbl (%eax),%edx
 19d:	84 d2                	test   %dl,%dl
 19f:	74 1d                	je     1be <strchr+0x2e>
    if(*s == c)
 1a1:	38 d3                	cmp    %dl,%bl
 1a3:	89 d9                	mov    %ebx,%ecx
 1a5:	75 0d                	jne    1b4 <strchr+0x24>
 1a7:	eb 17                	jmp    1c0 <strchr+0x30>
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1b0:	38 ca                	cmp    %cl,%dl
 1b2:	74 0c                	je     1c0 <strchr+0x30>
  for(; *s; s++)
 1b4:	83 c0 01             	add    $0x1,%eax
 1b7:	0f b6 10             	movzbl (%eax),%edx
 1ba:	84 d2                	test   %dl,%dl
 1bc:	75 f2                	jne    1b0 <strchr+0x20>
      return (char*)s;
  return 0;
 1be:	31 c0                	xor    %eax,%eax
}
 1c0:	5b                   	pop    %ebx
 1c1:	5d                   	pop    %ebp
 1c2:	c3                   	ret    
 1c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001d0 <gets>:

char*
gets(char *buf, int max)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	57                   	push   %edi
 1d4:	56                   	push   %esi
 1d5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d6:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 1d8:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 1db:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1de:	eb 29                	jmp    209 <gets+0x39>
    cc = read(0, &c, 1);
 1e0:	83 ec 04             	sub    $0x4,%esp
 1e3:	6a 01                	push   $0x1
 1e5:	57                   	push   %edi
 1e6:	6a 00                	push   $0x0
 1e8:	e8 2d 01 00 00       	call   31a <read>
    if(cc < 1)
 1ed:	83 c4 10             	add    $0x10,%esp
 1f0:	85 c0                	test   %eax,%eax
 1f2:	7e 1d                	jle    211 <gets+0x41>
      break;
    buf[i++] = c;
 1f4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1f8:	8b 55 08             	mov    0x8(%ebp),%edx
 1fb:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 1fd:	3c 0a                	cmp    $0xa,%al
    buf[i++] = c;
 1ff:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 203:	74 1b                	je     220 <gets+0x50>
 205:	3c 0d                	cmp    $0xd,%al
 207:	74 17                	je     220 <gets+0x50>
  for(i=0; i+1 < max; ){
 209:	8d 5e 01             	lea    0x1(%esi),%ebx
 20c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 20f:	7c cf                	jl     1e0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 211:	8b 45 08             	mov    0x8(%ebp),%eax
 214:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 218:	8d 65 f4             	lea    -0xc(%ebp),%esp
 21b:	5b                   	pop    %ebx
 21c:	5e                   	pop    %esi
 21d:	5f                   	pop    %edi
 21e:	5d                   	pop    %ebp
 21f:	c3                   	ret    
  buf[i] = '\0';
 220:	8b 45 08             	mov    0x8(%ebp),%eax
  for(i=0; i+1 < max; ){
 223:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 225:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 229:	8d 65 f4             	lea    -0xc(%ebp),%esp
 22c:	5b                   	pop    %ebx
 22d:	5e                   	pop    %esi
 22e:	5f                   	pop    %edi
 22f:	5d                   	pop    %ebp
 230:	c3                   	ret    
 231:	eb 0d                	jmp    240 <stat>
 233:	90                   	nop
 234:	90                   	nop
 235:	90                   	nop
 236:	90                   	nop
 237:	90                   	nop
 238:	90                   	nop
 239:	90                   	nop
 23a:	90                   	nop
 23b:	90                   	nop
 23c:	90                   	nop
 23d:	90                   	nop
 23e:	90                   	nop
 23f:	90                   	nop

00000240 <stat>:

int
stat(char *n, struct stat *st)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	56                   	push   %esi
 244:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 245:	83 ec 08             	sub    $0x8,%esp
 248:	6a 00                	push   $0x0
 24a:	ff 75 08             	pushl  0x8(%ebp)
 24d:	e8 f0 00 00 00       	call   342 <open>
  if(fd < 0)
 252:	83 c4 10             	add    $0x10,%esp
 255:	85 c0                	test   %eax,%eax
 257:	78 27                	js     280 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 259:	83 ec 08             	sub    $0x8,%esp
 25c:	ff 75 0c             	pushl  0xc(%ebp)
 25f:	89 c3                	mov    %eax,%ebx
 261:	50                   	push   %eax
 262:	e8 f3 00 00 00       	call   35a <fstat>
  close(fd);
 267:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 26a:	89 c6                	mov    %eax,%esi
  close(fd);
 26c:	e8 b9 00 00 00       	call   32a <close>
  return r;
 271:	83 c4 10             	add    $0x10,%esp
}
 274:	8d 65 f8             	lea    -0x8(%ebp),%esp
 277:	89 f0                	mov    %esi,%eax
 279:	5b                   	pop    %ebx
 27a:	5e                   	pop    %esi
 27b:	5d                   	pop    %ebp
 27c:	c3                   	ret    
 27d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 280:	be ff ff ff ff       	mov    $0xffffffff,%esi
 285:	eb ed                	jmp    274 <stat+0x34>
 287:	89 f6                	mov    %esi,%esi
 289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000290 <atoi>:

int
atoi(const char *s)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	53                   	push   %ebx
 294:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 297:	0f be 11             	movsbl (%ecx),%edx
 29a:	8d 42 d0             	lea    -0x30(%edx),%eax
 29d:	3c 09                	cmp    $0x9,%al
 29f:	b8 00 00 00 00       	mov    $0x0,%eax
 2a4:	77 1f                	ja     2c5 <atoi+0x35>
 2a6:	8d 76 00             	lea    0x0(%esi),%esi
 2a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 2b0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2b3:	83 c1 01             	add    $0x1,%ecx
 2b6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 2ba:	0f be 11             	movsbl (%ecx),%edx
 2bd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2c0:	80 fb 09             	cmp    $0x9,%bl
 2c3:	76 eb                	jbe    2b0 <atoi+0x20>
  return n;
}
 2c5:	5b                   	pop    %ebx
 2c6:	5d                   	pop    %ebp
 2c7:	c3                   	ret    
 2c8:	90                   	nop
 2c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002d0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	56                   	push   %esi
 2d4:	53                   	push   %ebx
 2d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
 2db:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2de:	85 db                	test   %ebx,%ebx
 2e0:	7e 14                	jle    2f6 <memmove+0x26>
 2e2:	31 d2                	xor    %edx,%edx
 2e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 2e8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2ec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2ef:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2f2:	39 da                	cmp    %ebx,%edx
 2f4:	75 f2                	jne    2e8 <memmove+0x18>
  return vdst;
}
 2f6:	5b                   	pop    %ebx
 2f7:	5e                   	pop    %esi
 2f8:	5d                   	pop    %ebp
 2f9:	c3                   	ret    

000002fa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2fa:	b8 01 00 00 00       	mov    $0x1,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <exit>:
SYSCALL(exit)
 302:	b8 02 00 00 00       	mov    $0x2,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <wait>:
SYSCALL(wait)
 30a:	b8 03 00 00 00       	mov    $0x3,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <pipe>:
SYSCALL(pipe)
 312:	b8 04 00 00 00       	mov    $0x4,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <read>:
SYSCALL(read)
 31a:	b8 05 00 00 00       	mov    $0x5,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <write>:
SYSCALL(write)
 322:	b8 10 00 00 00       	mov    $0x10,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <close>:
SYSCALL(close)
 32a:	b8 15 00 00 00       	mov    $0x15,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <kill>:
SYSCALL(kill)
 332:	b8 06 00 00 00       	mov    $0x6,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <exec>:
SYSCALL(exec)
 33a:	b8 07 00 00 00       	mov    $0x7,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <open>:
SYSCALL(open)
 342:	b8 0f 00 00 00       	mov    $0xf,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <mknod>:
SYSCALL(mknod)
 34a:	b8 11 00 00 00       	mov    $0x11,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <unlink>:
SYSCALL(unlink)
 352:	b8 12 00 00 00       	mov    $0x12,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <fstat>:
SYSCALL(fstat)
 35a:	b8 08 00 00 00       	mov    $0x8,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <link>:
SYSCALL(link)
 362:	b8 13 00 00 00       	mov    $0x13,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <mkdir>:
SYSCALL(mkdir)
 36a:	b8 14 00 00 00       	mov    $0x14,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <chdir>:
SYSCALL(chdir)
 372:	b8 09 00 00 00       	mov    $0x9,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <dup>:
SYSCALL(dup)
 37a:	b8 0a 00 00 00       	mov    $0xa,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <getpid>:
SYSCALL(getpid)
 382:	b8 0b 00 00 00       	mov    $0xb,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <sbrk>:
SYSCALL(sbrk)
 38a:	b8 0c 00 00 00       	mov    $0xc,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <sleep>:
SYSCALL(sleep)
 392:	b8 0d 00 00 00       	mov    $0xd,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <uptime>:
SYSCALL(uptime)
 39a:	b8 0e 00 00 00       	mov    $0xe,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <shutdown2>:
SYSCALL(shutdown2)
 3a2:	b8 16 00 00 00       	mov    $0x16,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    
 3aa:	66 90                	xchg   %ax,%ax
 3ac:	66 90                	xchg   %ax,%ax
 3ae:	66 90                	xchg   %ax,%ax

000003b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
 3b5:	53                   	push   %ebx
 3b6:	89 c6                	mov    %eax,%esi
 3b8:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3be:	85 db                	test   %ebx,%ebx
 3c0:	74 7e                	je     440 <printint+0x90>
 3c2:	89 d0                	mov    %edx,%eax
 3c4:	c1 e8 1f             	shr    $0x1f,%eax
 3c7:	84 c0                	test   %al,%al
 3c9:	74 75                	je     440 <printint+0x90>
    neg = 1;
    x = -xx;
 3cb:	89 d0                	mov    %edx,%eax
    neg = 1;
 3cd:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 3d4:	f7 d8                	neg    %eax
 3d6:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3d9:	31 ff                	xor    %edi,%edi
 3db:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3de:	89 ce                	mov    %ecx,%esi
 3e0:	eb 08                	jmp    3ea <printint+0x3a>
 3e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3e8:	89 cf                	mov    %ecx,%edi
 3ea:	31 d2                	xor    %edx,%edx
 3ec:	8d 4f 01             	lea    0x1(%edi),%ecx
 3ef:	f7 f6                	div    %esi
 3f1:	0f b6 92 28 08 00 00 	movzbl 0x828(%edx),%edx
  }while((x /= base) != 0);
 3f8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 3fa:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 3fd:	75 e9                	jne    3e8 <printint+0x38>
  if(neg)
 3ff:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 402:	8b 75 c0             	mov    -0x40(%ebp),%esi
 405:	85 c0                	test   %eax,%eax
 407:	74 08                	je     411 <printint+0x61>
    buf[i++] = '-';
 409:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 40e:	8d 4f 02             	lea    0x2(%edi),%ecx

  while(--i >= 0)
 411:	8d 79 ff             	lea    -0x1(%ecx),%edi
 414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 418:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
  write(fd, &c, 1);
 41d:	83 ec 04             	sub    $0x4,%esp
  while(--i >= 0)
 420:	83 ef 01             	sub    $0x1,%edi
  write(fd, &c, 1);
 423:	6a 01                	push   $0x1
 425:	53                   	push   %ebx
 426:	56                   	push   %esi
 427:	88 45 d7             	mov    %al,-0x29(%ebp)
 42a:	e8 f3 fe ff ff       	call   322 <write>
  while(--i >= 0)
 42f:	83 c4 10             	add    $0x10,%esp
 432:	83 ff ff             	cmp    $0xffffffff,%edi
 435:	75 e1                	jne    418 <printint+0x68>
    putc(fd, buf[i]);
}
 437:	8d 65 f4             	lea    -0xc(%ebp),%esp
 43a:	5b                   	pop    %ebx
 43b:	5e                   	pop    %esi
 43c:	5f                   	pop    %edi
 43d:	5d                   	pop    %ebp
 43e:	c3                   	ret    
 43f:	90                   	nop
    x = xx;
 440:	89 d0                	mov    %edx,%eax
  neg = 0;
 442:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 449:	eb 8b                	jmp    3d6 <printint+0x26>
 44b:	90                   	nop
 44c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000450 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	56                   	push   %esi
 455:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 456:	8d 45 10             	lea    0x10(%ebp),%eax
{
 459:	83 ec 2c             	sub    $0x2c,%esp
  for(i = 0; fmt[i]; i++){
 45c:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 45f:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 462:	89 45 d0             	mov    %eax,-0x30(%ebp)
 465:	0f b6 1e             	movzbl (%esi),%ebx
 468:	83 c6 01             	add    $0x1,%esi
 46b:	84 db                	test   %bl,%bl
 46d:	0f 84 b0 00 00 00    	je     523 <printf+0xd3>
 473:	31 d2                	xor    %edx,%edx
 475:	eb 39                	jmp    4b0 <printf+0x60>
 477:	89 f6                	mov    %esi,%esi
 479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 480:	83 f8 25             	cmp    $0x25,%eax
 483:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 486:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 48b:	74 18                	je     4a5 <printf+0x55>
  write(fd, &c, 1);
 48d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 490:	83 ec 04             	sub    $0x4,%esp
 493:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 496:	6a 01                	push   $0x1
 498:	50                   	push   %eax
 499:	57                   	push   %edi
 49a:	e8 83 fe ff ff       	call   322 <write>
 49f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4a2:	83 c4 10             	add    $0x10,%esp
 4a5:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 4a8:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4ac:	84 db                	test   %bl,%bl
 4ae:	74 73                	je     523 <printf+0xd3>
    if(state == 0){
 4b0:	85 d2                	test   %edx,%edx
    c = fmt[i] & 0xff;
 4b2:	0f be cb             	movsbl %bl,%ecx
 4b5:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4b8:	74 c6                	je     480 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ba:	83 fa 25             	cmp    $0x25,%edx
 4bd:	75 e6                	jne    4a5 <printf+0x55>
      if(c == 'd'){
 4bf:	83 f8 64             	cmp    $0x64,%eax
 4c2:	0f 84 f8 00 00 00    	je     5c0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4c8:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4ce:	83 f9 70             	cmp    $0x70,%ecx
 4d1:	74 5d                	je     530 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4d3:	83 f8 73             	cmp    $0x73,%eax
 4d6:	0f 84 84 00 00 00    	je     560 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4dc:	83 f8 63             	cmp    $0x63,%eax
 4df:	0f 84 ea 00 00 00    	je     5cf <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4e5:	83 f8 25             	cmp    $0x25,%eax
 4e8:	0f 84 c2 00 00 00    	je     5b0 <printf+0x160>
  write(fd, &c, 1);
 4ee:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4f1:	83 ec 04             	sub    $0x4,%esp
 4f4:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4f8:	6a 01                	push   $0x1
 4fa:	50                   	push   %eax
 4fb:	57                   	push   %edi
 4fc:	e8 21 fe ff ff       	call   322 <write>
 501:	83 c4 0c             	add    $0xc,%esp
 504:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 507:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 50a:	6a 01                	push   $0x1
 50c:	50                   	push   %eax
 50d:	57                   	push   %edi
 50e:	83 c6 01             	add    $0x1,%esi
 511:	e8 0c fe ff ff       	call   322 <write>
  for(i = 0; fmt[i]; i++){
 516:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 51a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 51d:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 51f:	84 db                	test   %bl,%bl
 521:	75 8d                	jne    4b0 <printf+0x60>
    }
  }
}
 523:	8d 65 f4             	lea    -0xc(%ebp),%esp
 526:	5b                   	pop    %ebx
 527:	5e                   	pop    %esi
 528:	5f                   	pop    %edi
 529:	5d                   	pop    %ebp
 52a:	c3                   	ret    
 52b:	90                   	nop
 52c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 16, 0);
 530:	83 ec 0c             	sub    $0xc,%esp
 533:	b9 10 00 00 00       	mov    $0x10,%ecx
 538:	6a 00                	push   $0x0
 53a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 53d:	89 f8                	mov    %edi,%eax
 53f:	8b 13                	mov    (%ebx),%edx
 541:	e8 6a fe ff ff       	call   3b0 <printint>
        ap++;
 546:	89 d8                	mov    %ebx,%eax
 548:	83 c4 10             	add    $0x10,%esp
      state = 0;
 54b:	31 d2                	xor    %edx,%edx
        ap++;
 54d:	83 c0 04             	add    $0x4,%eax
 550:	89 45 d0             	mov    %eax,-0x30(%ebp)
 553:	e9 4d ff ff ff       	jmp    4a5 <printf+0x55>
 558:	90                   	nop
 559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 560:	8b 45 d0             	mov    -0x30(%ebp),%eax
 563:	8b 18                	mov    (%eax),%ebx
        ap++;
 565:	83 c0 04             	add    $0x4,%eax
 568:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 56b:	85 db                	test   %ebx,%ebx
 56d:	74 7c                	je     5eb <printf+0x19b>
        while(*s != 0){
 56f:	0f b6 03             	movzbl (%ebx),%eax
 572:	84 c0                	test   %al,%al
 574:	74 29                	je     59f <printf+0x14f>
 576:	8d 76 00             	lea    0x0(%esi),%esi
 579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 580:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 583:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 586:	83 ec 04             	sub    $0x4,%esp
 589:	6a 01                	push   $0x1
          s++;
 58b:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 58e:	50                   	push   %eax
 58f:	57                   	push   %edi
 590:	e8 8d fd ff ff       	call   322 <write>
        while(*s != 0){
 595:	0f b6 03             	movzbl (%ebx),%eax
 598:	83 c4 10             	add    $0x10,%esp
 59b:	84 c0                	test   %al,%al
 59d:	75 e1                	jne    580 <printf+0x130>
      state = 0;
 59f:	31 d2                	xor    %edx,%edx
 5a1:	e9 ff fe ff ff       	jmp    4a5 <printf+0x55>
 5a6:	8d 76 00             	lea    0x0(%esi),%esi
 5a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  write(fd, &c, 1);
 5b0:	83 ec 04             	sub    $0x4,%esp
 5b3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 5b6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5b9:	6a 01                	push   $0x1
 5bb:	e9 4c ff ff ff       	jmp    50c <printf+0xbc>
        printint(fd, *ap, 10, 1);
 5c0:	83 ec 0c             	sub    $0xc,%esp
 5c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5c8:	6a 01                	push   $0x1
 5ca:	e9 6b ff ff ff       	jmp    53a <printf+0xea>
        putc(fd, *ap);
 5cf:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 5d2:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 5d5:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 5d7:	6a 01                	push   $0x1
        putc(fd, *ap);
 5d9:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5dc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5df:	50                   	push   %eax
 5e0:	57                   	push   %edi
 5e1:	e8 3c fd ff ff       	call   322 <write>
 5e6:	e9 5b ff ff ff       	jmp    546 <printf+0xf6>
        while(*s != 0){
 5eb:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 5f0:	bb 20 08 00 00       	mov    $0x820,%ebx
 5f5:	eb 89                	jmp    580 <printf+0x130>
 5f7:	66 90                	xchg   %ax,%ax
 5f9:	66 90                	xchg   %ax,%ax
 5fb:	66 90                	xchg   %ax,%ax
 5fd:	66 90                	xchg   %ax,%ax
 5ff:	90                   	nop

00000600 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 600:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 601:	a1 0c 0b 00 00       	mov    0xb0c,%eax
{
 606:	89 e5                	mov    %esp,%ebp
 608:	57                   	push   %edi
 609:	56                   	push   %esi
 60a:	53                   	push   %ebx
 60b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 60e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 610:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 613:	39 c8                	cmp    %ecx,%eax
 615:	73 19                	jae    630 <free+0x30>
 617:	89 f6                	mov    %esi,%esi
 619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 620:	39 d1                	cmp    %edx,%ecx
 622:	72 1c                	jb     640 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 624:	39 d0                	cmp    %edx,%eax
 626:	73 18                	jae    640 <free+0x40>
{
 628:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 62c:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62e:	72 f0                	jb     620 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 630:	39 d0                	cmp    %edx,%eax
 632:	72 f4                	jb     628 <free+0x28>
 634:	39 d1                	cmp    %edx,%ecx
 636:	73 f0                	jae    628 <free+0x28>
 638:	90                   	nop
 639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 640:	8b 73 fc             	mov    -0x4(%ebx),%esi
 643:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 646:	39 fa                	cmp    %edi,%edx
 648:	74 19                	je     663 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 64a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 64d:	8b 50 04             	mov    0x4(%eax),%edx
 650:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 653:	39 f1                	cmp    %esi,%ecx
 655:	74 23                	je     67a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 657:	89 08                	mov    %ecx,(%eax)
  freep = p;
 659:	a3 0c 0b 00 00       	mov    %eax,0xb0c
}
 65e:	5b                   	pop    %ebx
 65f:	5e                   	pop    %esi
 660:	5f                   	pop    %edi
 661:	5d                   	pop    %ebp
 662:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 663:	03 72 04             	add    0x4(%edx),%esi
 666:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 669:	8b 10                	mov    (%eax),%edx
 66b:	8b 12                	mov    (%edx),%edx
 66d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 670:	8b 50 04             	mov    0x4(%eax),%edx
 673:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 676:	39 f1                	cmp    %esi,%ecx
 678:	75 dd                	jne    657 <free+0x57>
    p->s.size += bp->s.size;
 67a:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 67d:	a3 0c 0b 00 00       	mov    %eax,0xb0c
    p->s.size += bp->s.size;
 682:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 685:	8b 53 f8             	mov    -0x8(%ebx),%edx
 688:	89 10                	mov    %edx,(%eax)
}
 68a:	5b                   	pop    %ebx
 68b:	5e                   	pop    %esi
 68c:	5f                   	pop    %edi
 68d:	5d                   	pop    %ebp
 68e:	c3                   	ret    
 68f:	90                   	nop

00000690 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	57                   	push   %edi
 694:	56                   	push   %esi
 695:	53                   	push   %ebx
 696:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 699:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 69c:	8b 15 0c 0b 00 00    	mov    0xb0c,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a2:	8d 78 07             	lea    0x7(%eax),%edi
 6a5:	c1 ef 03             	shr    $0x3,%edi
 6a8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 6ab:	85 d2                	test   %edx,%edx
 6ad:	0f 84 93 00 00 00    	je     746 <malloc+0xb6>
 6b3:	8b 02                	mov    (%edx),%eax
 6b5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6b8:	39 cf                	cmp    %ecx,%edi
 6ba:	76 64                	jbe    720 <malloc+0x90>
 6bc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 6c2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6c7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 6ca:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6d1:	eb 0e                	jmp    6e1 <malloc+0x51>
 6d3:	90                   	nop
 6d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6da:	8b 48 04             	mov    0x4(%eax),%ecx
 6dd:	39 cf                	cmp    %ecx,%edi
 6df:	76 3f                	jbe    720 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6e1:	39 05 0c 0b 00 00    	cmp    %eax,0xb0c
 6e7:	89 c2                	mov    %eax,%edx
 6e9:	75 ed                	jne    6d8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 6eb:	83 ec 0c             	sub    $0xc,%esp
 6ee:	56                   	push   %esi
 6ef:	e8 96 fc ff ff       	call   38a <sbrk>
  if(p == (char*)-1)
 6f4:	83 c4 10             	add    $0x10,%esp
 6f7:	83 f8 ff             	cmp    $0xffffffff,%eax
 6fa:	74 1c                	je     718 <malloc+0x88>
  hp->s.size = nu;
 6fc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6ff:	83 ec 0c             	sub    $0xc,%esp
 702:	83 c0 08             	add    $0x8,%eax
 705:	50                   	push   %eax
 706:	e8 f5 fe ff ff       	call   600 <free>
  return freep;
 70b:	8b 15 0c 0b 00 00    	mov    0xb0c,%edx
      if((p = morecore(nunits)) == 0)
 711:	83 c4 10             	add    $0x10,%esp
 714:	85 d2                	test   %edx,%edx
 716:	75 c0                	jne    6d8 <malloc+0x48>
        return 0;
 718:	31 c0                	xor    %eax,%eax
 71a:	eb 1c                	jmp    738 <malloc+0xa8>
 71c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 720:	39 cf                	cmp    %ecx,%edi
 722:	74 1c                	je     740 <malloc+0xb0>
        p->s.size -= nunits;
 724:	29 f9                	sub    %edi,%ecx
 726:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 729:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 72c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 72f:	89 15 0c 0b 00 00    	mov    %edx,0xb0c
      return (void*)(p + 1);
 735:	83 c0 08             	add    $0x8,%eax
  }
}
 738:	8d 65 f4             	lea    -0xc(%ebp),%esp
 73b:	5b                   	pop    %ebx
 73c:	5e                   	pop    %esi
 73d:	5f                   	pop    %edi
 73e:	5d                   	pop    %ebp
 73f:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 740:	8b 08                	mov    (%eax),%ecx
 742:	89 0a                	mov    %ecx,(%edx)
 744:	eb e9                	jmp    72f <malloc+0x9f>
    base.s.ptr = freep = prevp = &base;
 746:	c7 05 0c 0b 00 00 10 	movl   $0xb10,0xb0c
 74d:	0b 00 00 
 750:	c7 05 10 0b 00 00 10 	movl   $0xb10,0xb10
 757:	0b 00 00 
    base.s.size = 0;
 75a:	b8 10 0b 00 00       	mov    $0xb10,%eax
 75f:	c7 05 14 0b 00 00 00 	movl   $0x0,0xb14
 766:	00 00 00 
 769:	e9 4e ff ff ff       	jmp    6bc <malloc+0x2c>
