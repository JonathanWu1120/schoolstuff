
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 80 2e 10 80       	mov    $0x80102e80,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 6f 10 80       	push   $0x80106f40
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 75 41 00 00       	call   801041d0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 6f 10 80       	push   $0x80106f47
80100097:	50                   	push   %eax
80100098:	e8 23 40 00 00       	call   801040c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 e7 41 00 00       	call   801042d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 89 42 00 00       	call   801043f0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 3f 00 00       	call   80104100 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 6d 1f 00 00       	call   801020f0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 4e 6f 10 80       	push   $0x80106f4e
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 ed 3f 00 00       	call   801041a0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 27 1f 00 00       	jmp    801020f0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 5f 6f 10 80       	push   $0x80106f5f
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 ac 3f 00 00       	call   801041a0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 5c 3f 00 00       	call   80104160 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 c0 40 00 00       	call   801042d0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 8f 41 00 00       	jmp    801043f0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 66 6f 10 80       	push   $0x80106f66
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 cb 14 00 00       	call   80101750 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 3f 40 00 00       	call   801042d0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002a6:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 a5 10 80       	push   $0x8010a520
801002b8:	68 a0 ff 10 80       	push   $0x8010ffa0
801002bd:	e8 8e 3a 00 00       	call   80103d50 <sleep>
    while(input.r == input.w){
801002c2:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 b9 34 00 00       	call   80103790 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 a5 10 80       	push   $0x8010a520
801002e6:	e8 05 41 00 00       	call   801043f0 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 7d 13 00 00       	call   80101670 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 a5 10 80       	push   $0x8010a520
80100346:	e8 a5 40 00 00       	call   801043f0 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 1d 13 00 00       	call   80101670 <ilock>
  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        input.r--;
80100360:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  cons.locking = 0;
80100379:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100380:	00 00 00 
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 72 23 00 00       	call   80102700 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 6d 6f 10 80       	push   $0x80106f6d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 bb 78 10 80 	movl   $0x801078bb,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 33 3e 00 00       	call   801041f0 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 81 6f 10 80       	push   $0x80106f81
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
  if(panicked){
801003f0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 01 57 00 00       	call   80105b20 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100434:	89 ca                	mov    %ecx,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c6                	mov    %eax,%esi
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 ca                	mov    %ecx,%edx
80100449:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 
  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 9c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ebx
80100492:	89 f9                	mov    %edi,%ecx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 c8                	mov    %ecx,%eax
801004bd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 03             	mov    %ax,(%ebx)
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 48 56 00 00       	call   80105b20 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 3c 56 00 00       	call   80105b20 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 30 56 00 00       	call   80105b20 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	83 ef 50             	sub    $0x50,%edi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004fe:	be 07 00 00 00       	mov    $0x7,%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100503:	68 60 0e 00 00       	push   $0xe60
80100508:	68 a0 80 0b 80       	push   $0x800b80a0
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d 9c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	68 00 80 0b 80       	push   $0x800b8000
80100519:	e8 d2 3f 00 00       	call   801044f0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010051e:	b8 80 07 00 00       	mov    $0x780,%eax
80100523:	83 c4 0c             	add    $0xc,%esp
80100526:	29 f8                	sub    %edi,%eax
80100528:	01 c0                	add    %eax,%eax
8010052a:	50                   	push   %eax
8010052b:	6a 00                	push   $0x0
8010052d:	53                   	push   %ebx
8010052e:	e8 0d 3f 00 00       	call   80104440 <memset>
80100533:	89 f9                	mov    %edi,%ecx
80100535:	83 c4 10             	add    $0x10,%esp
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 85 6f 10 80       	push   $0x80106f85
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	bb 00 80 0b 80       	mov    $0x800b8000,%ebx
8010055a:	31 c9                	xor    %ecx,%ecx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 1c             	sub    $0x1c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
8010058d:	74 04                	je     80100593 <printint+0x13>
8010058f:	85 c0                	test   %eax,%eax
80100591:	78 57                	js     801005ea <printint+0x6a>
    x = xx;
80100593:	31 ff                	xor    %edi,%edi
  i = 0;
80100595:	31 c9                	xor    %ecx,%ecx
80100597:	eb 09                	jmp    801005a2 <printint+0x22>
80100599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a0:	89 d9                	mov    %ebx,%ecx
801005a2:	31 d2                	xor    %edx,%edx
801005a4:	8d 59 01             	lea    0x1(%ecx),%ebx
801005a7:	f7 f6                	div    %esi
801005a9:	0f b6 92 b0 6f 10 80 	movzbl -0x7fef9050(%edx),%edx
  }while((x /= base) != 0);
801005b0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005b2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005b6:	75 e8                	jne    801005a0 <printint+0x20>
  if(sign)
801005b8:	85 ff                	test   %edi,%edi
801005ba:	74 08                	je     801005c4 <printint+0x44>
    buf[i++] = '-';
801005bc:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
801005c1:	8d 59 02             	lea    0x2(%ecx),%ebx
  while(--i >= 0)
801005c4:	83 eb 01             	sub    $0x1,%ebx
801005c7:	89 f6                	mov    %esi,%esi
801005c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    consputc(buf[i]);
801005d0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  while(--i >= 0)
801005d5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005d8:	e8 13 fe ff ff       	call   801003f0 <consputc>
  while(--i >= 0)
801005dd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005e0:	75 ee                	jne    801005d0 <printint+0x50>
}
801005e2:	83 c4 1c             	add    $0x1c,%esp
801005e5:	5b                   	pop    %ebx
801005e6:	5e                   	pop    %esi
801005e7:	5f                   	pop    %edi
801005e8:	5d                   	pop    %ebp
801005e9:	c3                   	ret    
    x = -xx;
801005ea:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
801005ec:	bf 01 00 00 00       	mov    $0x1,%edi
    x = -xx;
801005f1:	eb a2                	jmp    80100595 <printint+0x15>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010060f:	e8 3c 11 00 00       	call   80101750 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 b0 3c 00 00       	call   801042d0 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 a4 3d 00 00       	call   801043f0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 1b 10 00 00       	call   80101670 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 27 01 00 00    	jne    801007a0 <cprintf+0x140>
  if (fmt == 0)
80100679:	8b 75 08             	mov    0x8(%ebp),%esi
8010067c:	85 f6                	test   %esi,%esi
8010067e:	0f 84 40 01 00 00    	je     801007c4 <cprintf+0x164>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100684:	0f b6 06             	movzbl (%esi),%eax
80100687:	31 db                	xor    %ebx,%ebx
80100689:	8d 7d 0c             	lea    0xc(%ebp),%edi
8010068c:	85 c0                	test   %eax,%eax
8010068e:	75 51                	jne    801006e1 <cprintf+0x81>
80100690:	eb 64                	jmp    801006f6 <cprintf+0x96>
80100692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    c = fmt[++i] & 0xff;
80100698:	83 c3 01             	add    $0x1,%ebx
8010069b:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
8010069f:	85 d2                	test   %edx,%edx
801006a1:	74 53                	je     801006f6 <cprintf+0x96>
    switch(c){
801006a3:	83 fa 70             	cmp    $0x70,%edx
801006a6:	74 7a                	je     80100722 <cprintf+0xc2>
801006a8:	7f 6e                	jg     80100718 <cprintf+0xb8>
801006aa:	83 fa 25             	cmp    $0x25,%edx
801006ad:	0f 84 ad 00 00 00    	je     80100760 <cprintf+0x100>
801006b3:	83 fa 64             	cmp    $0x64,%edx
801006b6:	0f 85 84 00 00 00    	jne    80100740 <cprintf+0xe0>
      printint(*argp++, 10, 1);
801006bc:	8d 47 04             	lea    0x4(%edi),%eax
801006bf:	b9 01 00 00 00       	mov    $0x1,%ecx
801006c4:	ba 0a 00 00 00       	mov    $0xa,%edx
801006c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006cc:	8b 07                	mov    (%edi),%eax
801006ce:	e8 ad fe ff ff       	call   80100580 <printint>
801006d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d6:	83 c3 01             	add    $0x1,%ebx
801006d9:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801006dd:	85 c0                	test   %eax,%eax
801006df:	74 15                	je     801006f6 <cprintf+0x96>
    if(c != '%'){
801006e1:	83 f8 25             	cmp    $0x25,%eax
801006e4:	74 b2                	je     80100698 <cprintf+0x38>
      consputc('%');
801006e6:	e8 05 fd ff ff       	call   801003f0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006eb:	83 c3 01             	add    $0x1,%ebx
801006ee:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801006f2:	85 c0                	test   %eax,%eax
801006f4:	75 eb                	jne    801006e1 <cprintf+0x81>
  if(locking)
801006f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006f9:	85 c0                	test   %eax,%eax
801006fb:	74 10                	je     8010070d <cprintf+0xad>
    release(&cons.lock);
801006fd:	83 ec 0c             	sub    $0xc,%esp
80100700:	68 20 a5 10 80       	push   $0x8010a520
80100705:	e8 e6 3c 00 00       	call   801043f0 <release>
8010070a:	83 c4 10             	add    $0x10,%esp
}
8010070d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100710:	5b                   	pop    %ebx
80100711:	5e                   	pop    %esi
80100712:	5f                   	pop    %edi
80100713:	5d                   	pop    %ebp
80100714:	c3                   	ret    
80100715:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100718:	83 fa 73             	cmp    $0x73,%edx
8010071b:	74 53                	je     80100770 <cprintf+0x110>
8010071d:	83 fa 78             	cmp    $0x78,%edx
80100720:	75 1e                	jne    80100740 <cprintf+0xe0>
      printint(*argp++, 16, 0);
80100722:	8d 47 04             	lea    0x4(%edi),%eax
80100725:	31 c9                	xor    %ecx,%ecx
80100727:	ba 10 00 00 00       	mov    $0x10,%edx
8010072c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010072f:	8b 07                	mov    (%edi),%eax
80100731:	e8 4a fe ff ff       	call   80100580 <printint>
80100736:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      break;
80100739:	eb 9b                	jmp    801006d6 <cprintf+0x76>
8010073b:	90                   	nop
8010073c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100740:	b8 25 00 00 00       	mov    $0x25,%eax
80100745:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100748:	e8 a3 fc ff ff       	call   801003f0 <consputc>
      consputc(c);
8010074d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100750:	89 d0                	mov    %edx,%eax
80100752:	e8 99 fc ff ff       	call   801003f0 <consputc>
      break;
80100757:	e9 7a ff ff ff       	jmp    801006d6 <cprintf+0x76>
8010075c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100760:	b8 25 00 00 00       	mov    $0x25,%eax
80100765:	e8 86 fc ff ff       	call   801003f0 <consputc>
8010076a:	e9 7c ff ff ff       	jmp    801006eb <cprintf+0x8b>
8010076f:	90                   	nop
      if((s = (char*)*argp++) == 0)
80100770:	8d 47 04             	lea    0x4(%edi),%eax
80100773:	8b 3f                	mov    (%edi),%edi
80100775:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100778:	85 ff                	test   %edi,%edi
8010077a:	75 0c                	jne    80100788 <cprintf+0x128>
8010077c:	eb 3a                	jmp    801007b8 <cprintf+0x158>
8010077e:	66 90                	xchg   %ax,%ax
      for(; *s; s++)
80100780:	83 c7 01             	add    $0x1,%edi
        consputc(*s);
80100783:	e8 68 fc ff ff       	call   801003f0 <consputc>
      for(; *s; s++)
80100788:	0f be 07             	movsbl (%edi),%eax
8010078b:	84 c0                	test   %al,%al
8010078d:	75 f1                	jne    80100780 <cprintf+0x120>
      if((s = (char*)*argp++) == 0)
8010078f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80100792:	e9 3f ff ff ff       	jmp    801006d6 <cprintf+0x76>
80100797:	89 f6                	mov    %esi,%esi
80100799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    acquire(&cons.lock);
801007a0:	83 ec 0c             	sub    $0xc,%esp
801007a3:	68 20 a5 10 80       	push   $0x8010a520
801007a8:	e8 23 3b 00 00       	call   801042d0 <acquire>
801007ad:	83 c4 10             	add    $0x10,%esp
801007b0:	e9 c4 fe ff ff       	jmp    80100679 <cprintf+0x19>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
      for(; *s; s++)
801007b8:	b8 28 00 00 00       	mov    $0x28,%eax
        s = "(null)";
801007bd:	bf 98 6f 10 80       	mov    $0x80106f98,%edi
801007c2:	eb bc                	jmp    80100780 <cprintf+0x120>
    panic("null fmt");
801007c4:	83 ec 0c             	sub    $0xc,%esp
801007c7:	68 9f 6f 10 80       	push   $0x80106f9f
801007cc:	e8 9f fb ff ff       	call   80100370 <panic>
801007d1:	eb 0d                	jmp    801007e0 <consoleintr>
801007d3:	90                   	nop
801007d4:	90                   	nop
801007d5:	90                   	nop
801007d6:	90                   	nop
801007d7:	90                   	nop
801007d8:	90                   	nop
801007d9:	90                   	nop
801007da:	90                   	nop
801007db:	90                   	nop
801007dc:	90                   	nop
801007dd:	90                   	nop
801007de:	90                   	nop
801007df:	90                   	nop

801007e0 <consoleintr>:
{
801007e0:	55                   	push   %ebp
801007e1:	89 e5                	mov    %esp,%ebp
801007e3:	57                   	push   %edi
801007e4:	56                   	push   %esi
801007e5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007e6:	31 f6                	xor    %esi,%esi
{
801007e8:	83 ec 18             	sub    $0x18,%esp
801007eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007ee:	68 20 a5 10 80       	push   $0x8010a520
801007f3:	e8 d8 3a 00 00       	call   801042d0 <acquire>
  while((c = getc()) >= 0){
801007f8:	83 c4 10             	add    $0x10,%esp
801007fb:	90                   	nop
801007fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100800:	ff d3                	call   *%ebx
80100802:	85 c0                	test   %eax,%eax
80100804:	89 c7                	mov    %eax,%edi
80100806:	78 48                	js     80100850 <consoleintr+0x70>
    switch(c){
80100808:	83 ff 10             	cmp    $0x10,%edi
8010080b:	0f 84 3f 01 00 00    	je     80100950 <consoleintr+0x170>
80100811:	7e 5d                	jle    80100870 <consoleintr+0x90>
80100813:	83 ff 15             	cmp    $0x15,%edi
80100816:	0f 84 dc 00 00 00    	je     801008f8 <consoleintr+0x118>
8010081c:	83 ff 7f             	cmp    $0x7f,%edi
8010081f:	75 54                	jne    80100875 <consoleintr+0x95>
      if(input.e != input.w){
80100821:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100826:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010082c:	74 d2                	je     80100800 <consoleintr+0x20>
        input.e--;
8010082e:	83 e8 01             	sub    $0x1,%eax
80100831:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100836:	b8 00 01 00 00       	mov    $0x100,%eax
8010083b:	e8 b0 fb ff ff       	call   801003f0 <consputc>
  while((c = getc()) >= 0){
80100840:	ff d3                	call   *%ebx
80100842:	85 c0                	test   %eax,%eax
80100844:	89 c7                	mov    %eax,%edi
80100846:	79 c0                	jns    80100808 <consoleintr+0x28>
80100848:	90                   	nop
80100849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100850:	83 ec 0c             	sub    $0xc,%esp
80100853:	68 20 a5 10 80       	push   $0x8010a520
80100858:	e8 93 3b 00 00       	call   801043f0 <release>
  if(doprocdump) {
8010085d:	83 c4 10             	add    $0x10,%esp
80100860:	85 f6                	test   %esi,%esi
80100862:	0f 85 f8 00 00 00    	jne    80100960 <consoleintr+0x180>
}
80100868:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010086b:	5b                   	pop    %ebx
8010086c:	5e                   	pop    %esi
8010086d:	5f                   	pop    %edi
8010086e:	5d                   	pop    %ebp
8010086f:	c3                   	ret    
    switch(c){
80100870:	83 ff 08             	cmp    $0x8,%edi
80100873:	74 ac                	je     80100821 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100875:	85 ff                	test   %edi,%edi
80100877:	74 87                	je     80100800 <consoleintr+0x20>
80100879:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010087e:	89 c2                	mov    %eax,%edx
80100880:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100886:	83 fa 7f             	cmp    $0x7f,%edx
80100889:	0f 87 71 ff ff ff    	ja     80100800 <consoleintr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
8010088f:	8d 50 01             	lea    0x1(%eax),%edx
80100892:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100895:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100898:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
8010089e:	0f 84 c8 00 00 00    	je     8010096c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008a4:	89 f9                	mov    %edi,%ecx
801008a6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008ac:	89 f8                	mov    %edi,%eax
801008ae:	e8 3d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008b3:	83 ff 0a             	cmp    $0xa,%edi
801008b6:	0f 84 c1 00 00 00    	je     8010097d <consoleintr+0x19d>
801008bc:	83 ff 04             	cmp    $0x4,%edi
801008bf:	0f 84 b8 00 00 00    	je     8010097d <consoleintr+0x19d>
801008c5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008ca:	83 e8 80             	sub    $0xffffff80,%eax
801008cd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
801008d3:	0f 85 27 ff ff ff    	jne    80100800 <consoleintr+0x20>
          wakeup(&input.r);
801008d9:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
801008dc:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008e1:	68 a0 ff 10 80       	push   $0x8010ffa0
801008e6:	e8 25 36 00 00       	call   80103f10 <wakeup>
801008eb:	83 c4 10             	add    $0x10,%esp
801008ee:	e9 0d ff ff ff       	jmp    80100800 <consoleintr+0x20>
801008f3:	90                   	nop
801008f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
801008f8:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008fd:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100903:	75 2b                	jne    80100930 <consoleintr+0x150>
80100905:	e9 f6 fe ff ff       	jmp    80100800 <consoleintr+0x20>
8010090a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100910:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100915:	b8 00 01 00 00       	mov    $0x100,%eax
8010091a:	e8 d1 fa ff ff       	call   801003f0 <consputc>
      while(input.e != input.w &&
8010091f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100924:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010092a:	0f 84 d0 fe ff ff    	je     80100800 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100930:	83 e8 01             	sub    $0x1,%eax
80100933:	89 c2                	mov    %eax,%edx
80100935:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100938:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010093f:	75 cf                	jne    80100910 <consoleintr+0x130>
80100941:	e9 ba fe ff ff       	jmp    80100800 <consoleintr+0x20>
80100946:	8d 76 00             	lea    0x0(%esi),%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      doprocdump = 1;
80100950:	be 01 00 00 00       	mov    $0x1,%esi
80100955:	e9 a6 fe ff ff       	jmp    80100800 <consoleintr+0x20>
8010095a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100960:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100963:	5b                   	pop    %ebx
80100964:	5e                   	pop    %esi
80100965:	5f                   	pop    %edi
80100966:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100967:	e9 94 36 00 00       	jmp    80104000 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
8010096c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100973:	b8 0a 00 00 00       	mov    $0xa,%eax
80100978:	e8 73 fa ff ff       	call   801003f0 <consputc>
8010097d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100982:	e9 52 ff ff ff       	jmp    801008d9 <consoleintr+0xf9>
80100987:	89 f6                	mov    %esi,%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100990 <consoleinit>:

void
consoleinit(void)
{
80100990:	55                   	push   %ebp
80100991:	89 e5                	mov    %esp,%ebp
80100993:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100996:	68 a8 6f 10 80       	push   $0x80106fa8
8010099b:	68 20 a5 10 80       	push   $0x8010a520
801009a0:	e8 2b 38 00 00       	call   801041d0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009a5:	58                   	pop    %eax
801009a6:	5a                   	pop    %edx
801009a7:	6a 00                	push   $0x0
801009a9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009ab:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009b2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009b5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009bc:	02 10 80 
  cons.locking = 1;
801009bf:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009c6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009c9:	e8 d2 18 00 00       	call   801022a0 <ioapicenable>
}
801009ce:	83 c4 10             	add    $0x10,%esp
801009d1:	c9                   	leave  
801009d2:	c3                   	ret    
801009d3:	66 90                	xchg   %ax,%ax
801009d5:	66 90                	xchg   %ax,%ax
801009d7:	66 90                	xchg   %ax,%ax
801009d9:	66 90                	xchg   %ax,%ax
801009db:	66 90                	xchg   %ax,%ax
801009dd:	66 90                	xchg   %ax,%ax
801009df:	90                   	nop

801009e0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009e0:	55                   	push   %ebp
801009e1:	89 e5                	mov    %esp,%ebp
801009e3:	57                   	push   %edi
801009e4:	56                   	push   %esi
801009e5:	53                   	push   %ebx
801009e6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ec:	e8 9f 2d 00 00       	call   80103790 <myproc>
801009f1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009f7:	e8 74 21 00 00       	call   80102b70 <begin_op>

  if((ip = namei(path)) == 0){
801009fc:	83 ec 0c             	sub    $0xc,%esp
801009ff:	ff 75 08             	pushl  0x8(%ebp)
80100a02:	e8 b9 14 00 00       	call   80101ec0 <namei>
80100a07:	83 c4 10             	add    $0x10,%esp
80100a0a:	85 c0                	test   %eax,%eax
80100a0c:	0f 84 9c 01 00 00    	je     80100bae <exec+0x1ce>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a12:	83 ec 0c             	sub    $0xc,%esp
80100a15:	89 c3                	mov    %eax,%ebx
80100a17:	50                   	push   %eax
80100a18:	e8 53 0c 00 00       	call   80101670 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a1d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a23:	6a 34                	push   $0x34
80100a25:	6a 00                	push   $0x0
80100a27:	50                   	push   %eax
80100a28:	53                   	push   %ebx
80100a29:	e8 22 0f 00 00       	call   80101950 <readi>
80100a2e:	83 c4 20             	add    $0x20,%esp
80100a31:	83 f8 34             	cmp    $0x34,%eax
80100a34:	74 22                	je     80100a58 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a36:	83 ec 0c             	sub    $0xc,%esp
80100a39:	53                   	push   %ebx
80100a3a:	e8 c1 0e 00 00       	call   80101900 <iunlockput>
    end_op();
80100a3f:	e8 9c 21 00 00       	call   80102be0 <end_op>
80100a44:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a4f:	5b                   	pop    %ebx
80100a50:	5e                   	pop    %esi
80100a51:	5f                   	pop    %edi
80100a52:	5d                   	pop    %ebp
80100a53:	c3                   	ret    
80100a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a58:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a5f:	45 4c 46 
80100a62:	75 d2                	jne    80100a36 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a64:	e8 37 62 00 00       	call   80106ca0 <setupkvm>
80100a69:	85 c0                	test   %eax,%eax
80100a6b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a71:	74 c3                	je     80100a36 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a73:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a7a:	00 
80100a7b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a81:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a88:	00 00 00 
80100a8b:	0f 84 c5 00 00 00    	je     80100b56 <exec+0x176>
80100a91:	31 ff                	xor    %edi,%edi
80100a93:	eb 18                	jmp    80100aad <exec+0xcd>
80100a95:	8d 76 00             	lea    0x0(%esi),%esi
80100a98:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a9f:	83 c7 01             	add    $0x1,%edi
80100aa2:	83 c6 20             	add    $0x20,%esi
80100aa5:	39 f8                	cmp    %edi,%eax
80100aa7:	0f 8e a9 00 00 00    	jle    80100b56 <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100aad:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ab3:	6a 20                	push   $0x20
80100ab5:	56                   	push   %esi
80100ab6:	50                   	push   %eax
80100ab7:	53                   	push   %ebx
80100ab8:	e8 93 0e 00 00       	call   80101950 <readi>
80100abd:	83 c4 10             	add    $0x10,%esp
80100ac0:	83 f8 20             	cmp    $0x20,%eax
80100ac3:	75 7b                	jne    80100b40 <exec+0x160>
    if(ph.type != ELF_PROG_LOAD)
80100ac5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acc:	75 ca                	jne    80100a98 <exec+0xb8>
    if(ph.memsz < ph.filesz)
80100ace:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ada:	72 64                	jb     80100b40 <exec+0x160>
80100adc:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae2:	72 5c                	jb     80100b40 <exec+0x160>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ae4:	83 ec 04             	sub    $0x4,%esp
80100ae7:	50                   	push   %eax
80100ae8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100aee:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af4:	e8 07 60 00 00       	call   80106b00 <allocuvm>
80100af9:	83 c4 10             	add    $0x10,%esp
80100afc:	85 c0                	test   %eax,%eax
80100afe:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b04:	74 3a                	je     80100b40 <exec+0x160>
    if(ph.vaddr % PGSIZE != 0)
80100b06:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b11:	75 2d                	jne    80100b40 <exec+0x160>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b13:	83 ec 0c             	sub    $0xc,%esp
80100b16:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b22:	53                   	push   %ebx
80100b23:	50                   	push   %eax
80100b24:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b2a:	e8 11 5f 00 00       	call   80106a40 <loaduvm>
80100b2f:	83 c4 20             	add    $0x20,%esp
80100b32:	85 c0                	test   %eax,%eax
80100b34:	0f 89 5e ff ff ff    	jns    80100a98 <exec+0xb8>
80100b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    freevm(pgdir);
80100b40:	83 ec 0c             	sub    $0xc,%esp
80100b43:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b49:	e8 d2 60 00 00       	call   80106c20 <freevm>
80100b4e:	83 c4 10             	add    $0x10,%esp
80100b51:	e9 e0 fe ff ff       	jmp    80100a36 <exec+0x56>
  iunlockput(ip);
80100b56:	83 ec 0c             	sub    $0xc,%esp
80100b59:	53                   	push   %ebx
80100b5a:	e8 a1 0d 00 00       	call   80101900 <iunlockput>
  end_op();
80100b5f:	e8 7c 20 00 00       	call   80102be0 <end_op>
  sz = PGROUNDUP(sz);
80100b64:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b6a:	83 c4 0c             	add    $0xc,%esp
  sz = PGROUNDUP(sz);
80100b6d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b77:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b7d:	52                   	push   %edx
80100b7e:	50                   	push   %eax
80100b7f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b85:	e8 76 5f 00 00       	call   80106b00 <allocuvm>
80100b8a:	83 c4 10             	add    $0x10,%esp
80100b8d:	85 c0                	test   %eax,%eax
80100b8f:	89 c6                	mov    %eax,%esi
80100b91:	75 3a                	jne    80100bcd <exec+0x1ed>
    freevm(pgdir);
80100b93:	83 ec 0c             	sub    $0xc,%esp
80100b96:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b9c:	e8 7f 60 00 00       	call   80106c20 <freevm>
80100ba1:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba9:	e9 9e fe ff ff       	jmp    80100a4c <exec+0x6c>
    end_op();
80100bae:	e8 2d 20 00 00       	call   80102be0 <end_op>
    cprintf("exec: fail\n");
80100bb3:	83 ec 0c             	sub    $0xc,%esp
80100bb6:	68 c1 6f 10 80       	push   $0x80106fc1
80100bbb:	e8 a0 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bc0:	83 c4 10             	add    $0x10,%esp
80100bc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc8:	e9 7f fe ff ff       	jmp    80100a4c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bcd:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bd3:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bd6:	31 ff                	xor    %edi,%edi
80100bd8:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bda:	50                   	push   %eax
80100bdb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100be1:	e8 5a 61 00 00       	call   80106d40 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100be6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100be9:	83 c4 10             	add    $0x10,%esp
80100bec:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100bf2:	8b 00                	mov    (%eax),%eax
80100bf4:	85 c0                	test   %eax,%eax
80100bf6:	74 79                	je     80100c71 <exec+0x291>
80100bf8:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100bfe:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c04:	eb 13                	jmp    80100c19 <exec+0x239>
80100c06:	8d 76 00             	lea    0x0(%esi),%esi
80100c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(argc >= MAXARG)
80100c10:	83 ff 20             	cmp    $0x20,%edi
80100c13:	0f 84 7a ff ff ff    	je     80100b93 <exec+0x1b3>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c19:	83 ec 0c             	sub    $0xc,%esp
80100c1c:	50                   	push   %eax
80100c1d:	e8 3e 3a 00 00       	call   80104660 <strlen>
80100c22:	f7 d0                	not    %eax
80100c24:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c26:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c29:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c2a:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c2d:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c30:	e8 2b 3a 00 00       	call   80104660 <strlen>
80100c35:	83 c0 01             	add    $0x1,%eax
80100c38:	50                   	push   %eax
80100c39:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c3c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c3f:	53                   	push   %ebx
80100c40:	56                   	push   %esi
80100c41:	e8 4a 62 00 00       	call   80106e90 <copyout>
80100c46:	83 c4 20             	add    $0x20,%esp
80100c49:	85 c0                	test   %eax,%eax
80100c4b:	0f 88 42 ff ff ff    	js     80100b93 <exec+0x1b3>
  for(argc = 0; argv[argc]; argc++) {
80100c51:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c54:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c5b:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c64:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c67:	85 c0                	test   %eax,%eax
80100c69:	75 a5                	jne    80100c10 <exec+0x230>
80100c6b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c71:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c78:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c7a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c81:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100c85:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c8c:	ff ff ff 
  ustack[1] = argc;
80100c8f:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c95:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100c97:	83 c0 0c             	add    $0xc,%eax
80100c9a:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c9c:	50                   	push   %eax
80100c9d:	52                   	push   %edx
80100c9e:	53                   	push   %ebx
80100c9f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca5:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cab:	e8 e0 61 00 00       	call   80106e90 <copyout>
80100cb0:	83 c4 10             	add    $0x10,%esp
80100cb3:	85 c0                	test   %eax,%eax
80100cb5:	0f 88 d8 fe ff ff    	js     80100b93 <exec+0x1b3>
  for(last=s=path; *s; s++)
80100cbb:	8b 45 08             	mov    0x8(%ebp),%eax
80100cbe:	0f b6 10             	movzbl (%eax),%edx
80100cc1:	84 d2                	test   %dl,%dl
80100cc3:	74 19                	je     80100cde <exec+0x2fe>
80100cc5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cc8:	83 c0 01             	add    $0x1,%eax
      last = s+1;
80100ccb:	80 fa 2f             	cmp    $0x2f,%dl
  for(last=s=path; *s; s++)
80100cce:	0f b6 10             	movzbl (%eax),%edx
      last = s+1;
80100cd1:	0f 44 c8             	cmove  %eax,%ecx
80100cd4:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100cd7:	84 d2                	test   %dl,%dl
80100cd9:	75 f0                	jne    80100ccb <exec+0x2eb>
80100cdb:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cde:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100ce4:	50                   	push   %eax
80100ce5:	6a 10                	push   $0x10
80100ce7:	ff 75 08             	pushl  0x8(%ebp)
80100cea:	89 f8                	mov    %edi,%eax
80100cec:	83 c0 6c             	add    $0x6c,%eax
80100cef:	50                   	push   %eax
80100cf0:	e8 2b 39 00 00       	call   80104620 <safestrcpy>
  curproc->pgdir = pgdir;
80100cf5:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100cfb:	89 f8                	mov    %edi,%eax
80100cfd:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d00:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d02:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d05:	89 c1                	mov    %eax,%ecx
80100d07:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d0d:	8b 40 18             	mov    0x18(%eax),%eax
80100d10:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d13:	8b 41 18             	mov    0x18(%ecx),%eax
80100d16:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d19:	89 0c 24             	mov    %ecx,(%esp)
80100d1c:	e8 8f 5b 00 00       	call   801068b0 <switchuvm>
  freevm(oldpgdir);
80100d21:	89 3c 24             	mov    %edi,(%esp)
80100d24:	e8 f7 5e 00 00       	call   80106c20 <freevm>
  return 0;
80100d29:	83 c4 10             	add    $0x10,%esp
80100d2c:	31 c0                	xor    %eax,%eax
80100d2e:	e9 19 fd ff ff       	jmp    80100a4c <exec+0x6c>
80100d33:	66 90                	xchg   %ax,%ax
80100d35:	66 90                	xchg   %ax,%ax
80100d37:	66 90                	xchg   %ax,%ax
80100d39:	66 90                	xchg   %ax,%ax
80100d3b:	66 90                	xchg   %ax,%ax
80100d3d:	66 90                	xchg   %ax,%ax
80100d3f:	90                   	nop

80100d40 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d40:	55                   	push   %ebp
80100d41:	89 e5                	mov    %esp,%ebp
80100d43:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d46:	68 cd 6f 10 80       	push   $0x80106fcd
80100d4b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d50:	e8 7b 34 00 00       	call   801041d0 <initlock>
}
80100d55:	83 c4 10             	add    $0x10,%esp
80100d58:	c9                   	leave  
80100d59:	c3                   	ret    
80100d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d64:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d69:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d6c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d71:	e8 5a 35 00 00       	call   801042d0 <acquire>
80100d76:	83 c4 10             	add    $0x10,%esp
80100d79:	eb 10                	jmp    80100d8b <filealloc+0x2b>
80100d7b:	90                   	nop
80100d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d80:	83 c3 18             	add    $0x18,%ebx
80100d83:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d89:	73 25                	jae    80100db0 <filealloc+0x50>
    if(f->ref == 0){
80100d8b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d8e:	85 c0                	test   %eax,%eax
80100d90:	75 ee                	jne    80100d80 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d92:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100d95:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d9c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100da1:	e8 4a 36 00 00       	call   801043f0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100da6:	89 d8                	mov    %ebx,%eax
      return f;
80100da8:	83 c4 10             	add    $0x10,%esp
}
80100dab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dae:	c9                   	leave  
80100daf:	c3                   	ret    
  release(&ftable.lock);
80100db0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100db3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100db5:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dba:	e8 31 36 00 00       	call   801043f0 <release>
}
80100dbf:	89 d8                	mov    %ebx,%eax
  return 0;
80100dc1:	83 c4 10             	add    $0x10,%esp
}
80100dc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dc7:	c9                   	leave  
80100dc8:	c3                   	ret    
80100dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100dd0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dd0:	55                   	push   %ebp
80100dd1:	89 e5                	mov    %esp,%ebp
80100dd3:	53                   	push   %ebx
80100dd4:	83 ec 10             	sub    $0x10,%esp
80100dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dda:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ddf:	e8 ec 34 00 00       	call   801042d0 <acquire>
  if(f->ref < 1)
80100de4:	8b 43 04             	mov    0x4(%ebx),%eax
80100de7:	83 c4 10             	add    $0x10,%esp
80100dea:	85 c0                	test   %eax,%eax
80100dec:	7e 1a                	jle    80100e08 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dee:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100df1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100df4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100df7:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dfc:	e8 ef 35 00 00       	call   801043f0 <release>
  return f;
}
80100e01:	89 d8                	mov    %ebx,%eax
80100e03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e06:	c9                   	leave  
80100e07:	c3                   	ret    
    panic("filedup");
80100e08:	83 ec 0c             	sub    $0xc,%esp
80100e0b:	68 d4 6f 10 80       	push   $0x80106fd4
80100e10:	e8 5b f5 ff ff       	call   80100370 <panic>
80100e15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e20 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	57                   	push   %edi
80100e24:	56                   	push   %esi
80100e25:	53                   	push   %ebx
80100e26:	83 ec 28             	sub    $0x28,%esp
80100e29:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e2c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e31:	e8 9a 34 00 00       	call   801042d0 <acquire>
  if(f->ref < 1)
80100e36:	8b 47 04             	mov    0x4(%edi),%eax
80100e39:	83 c4 10             	add    $0x10,%esp
80100e3c:	85 c0                	test   %eax,%eax
80100e3e:	0f 8e 9b 00 00 00    	jle    80100edf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e44:	83 e8 01             	sub    $0x1,%eax
80100e47:	85 c0                	test   %eax,%eax
80100e49:	89 47 04             	mov    %eax,0x4(%edi)
80100e4c:	74 1a                	je     80100e68 <fileclose+0x48>
    release(&ftable.lock);
80100e4e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e58:	5b                   	pop    %ebx
80100e59:	5e                   	pop    %esi
80100e5a:	5f                   	pop    %edi
80100e5b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e5c:	e9 8f 35 00 00       	jmp    801043f0 <release>
80100e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e68:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e6c:	8b 1f                	mov    (%edi),%ebx
  release(&ftable.lock);
80100e6e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e71:	8b 77 0c             	mov    0xc(%edi),%esi
  f->type = FD_NONE;
80100e74:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  ff = *f;
80100e7a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e7d:	8b 47 10             	mov    0x10(%edi),%eax
  release(&ftable.lock);
80100e80:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100e85:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100e88:	e8 63 35 00 00       	call   801043f0 <release>
  if(ff.type == FD_PIPE)
80100e8d:	83 c4 10             	add    $0x10,%esp
80100e90:	83 fb 01             	cmp    $0x1,%ebx
80100e93:	74 13                	je     80100ea8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100e95:	83 fb 02             	cmp    $0x2,%ebx
80100e98:	74 26                	je     80100ec0 <fileclose+0xa0>
}
80100e9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e9d:	5b                   	pop    %ebx
80100e9e:	5e                   	pop    %esi
80100e9f:	5f                   	pop    %edi
80100ea0:	5d                   	pop    %ebp
80100ea1:	c3                   	ret    
80100ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ea8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100eac:	83 ec 08             	sub    $0x8,%esp
80100eaf:	53                   	push   %ebx
80100eb0:	56                   	push   %esi
80100eb1:	e8 4a 24 00 00       	call   80103300 <pipeclose>
80100eb6:	83 c4 10             	add    $0x10,%esp
80100eb9:	eb df                	jmp    80100e9a <fileclose+0x7a>
80100ebb:	90                   	nop
80100ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ec0:	e8 ab 1c 00 00       	call   80102b70 <begin_op>
    iput(ff.ip);
80100ec5:	83 ec 0c             	sub    $0xc,%esp
80100ec8:	ff 75 e0             	pushl  -0x20(%ebp)
80100ecb:	e8 d0 08 00 00       	call   801017a0 <iput>
    end_op();
80100ed0:	83 c4 10             	add    $0x10,%esp
}
80100ed3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ed6:	5b                   	pop    %ebx
80100ed7:	5e                   	pop    %esi
80100ed8:	5f                   	pop    %edi
80100ed9:	5d                   	pop    %ebp
    end_op();
80100eda:	e9 01 1d 00 00       	jmp    80102be0 <end_op>
    panic("fileclose");
80100edf:	83 ec 0c             	sub    $0xc,%esp
80100ee2:	68 dc 6f 10 80       	push   $0x80106fdc
80100ee7:	e8 84 f4 ff ff       	call   80100370 <panic>
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 04             	sub    $0x4,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100efa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100efd:	75 31                	jne    80100f30 <filestat+0x40>
    ilock(f->ip);
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	ff 73 10             	pushl  0x10(%ebx)
80100f05:	e8 66 07 00 00       	call   80101670 <ilock>
    stati(f->ip, st);
80100f0a:	58                   	pop    %eax
80100f0b:	5a                   	pop    %edx
80100f0c:	ff 75 0c             	pushl  0xc(%ebp)
80100f0f:	ff 73 10             	pushl  0x10(%ebx)
80100f12:	e8 09 0a 00 00       	call   80101920 <stati>
    iunlock(f->ip);
80100f17:	59                   	pop    %ecx
80100f18:	ff 73 10             	pushl  0x10(%ebx)
80100f1b:	e8 30 08 00 00       	call   80101750 <iunlock>
    return 0;
80100f20:	83 c4 10             	add    $0x10,%esp
80100f23:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f28:	c9                   	leave  
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f38:	c9                   	leave  
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f40 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 0c             	sub    $0xc,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f52:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f56:	74 60                	je     80100fb8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f58:	8b 03                	mov    (%ebx),%eax
80100f5a:	83 f8 01             	cmp    $0x1,%eax
80100f5d:	74 41                	je     80100fa0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f5f:	83 f8 02             	cmp    $0x2,%eax
80100f62:	75 5b                	jne    80100fbf <fileread+0x7f>
    ilock(f->ip);
80100f64:	83 ec 0c             	sub    $0xc,%esp
80100f67:	ff 73 10             	pushl  0x10(%ebx)
80100f6a:	e8 01 07 00 00       	call   80101670 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f6f:	57                   	push   %edi
80100f70:	ff 73 14             	pushl  0x14(%ebx)
80100f73:	56                   	push   %esi
80100f74:	ff 73 10             	pushl  0x10(%ebx)
80100f77:	e8 d4 09 00 00       	call   80101950 <readi>
80100f7c:	83 c4 20             	add    $0x20,%esp
80100f7f:	85 c0                	test   %eax,%eax
80100f81:	89 c6                	mov    %eax,%esi
80100f83:	7e 03                	jle    80100f88 <fileread+0x48>
      f->off += r;
80100f85:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f88:	83 ec 0c             	sub    $0xc,%esp
80100f8b:	ff 73 10             	pushl  0x10(%ebx)
80100f8e:	e8 bd 07 00 00       	call   80101750 <iunlock>
    return r;
80100f93:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f99:	89 f0                	mov    %esi,%eax
80100f9b:	5b                   	pop    %ebx
80100f9c:	5e                   	pop    %esi
80100f9d:	5f                   	pop    %edi
80100f9e:	5d                   	pop    %ebp
80100f9f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fa0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fa3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fa6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa9:	5b                   	pop    %ebx
80100faa:	5e                   	pop    %esi
80100fab:	5f                   	pop    %edi
80100fac:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fad:	e9 fe 24 00 00       	jmp    801034b0 <piperead>
80100fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fb8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fbd:	eb d7                	jmp    80100f96 <fileread+0x56>
  panic("fileread");
80100fbf:	83 ec 0c             	sub    $0xc,%esp
80100fc2:	68 e6 6f 10 80       	push   $0x80106fe6
80100fc7:	e8 a4 f3 ff ff       	call   80100370 <panic>
80100fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fd0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	57                   	push   %edi
80100fd4:	56                   	push   %esi
80100fd5:	53                   	push   %ebx
80100fd6:	83 ec 1c             	sub    $0x1c,%esp
80100fd9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fdf:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80100fe3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fe6:	8b 45 10             	mov    0x10(%ebp),%eax
80100fe9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80100fec:	0f 84 aa 00 00 00    	je     8010109c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80100ff2:	8b 06                	mov    (%esi),%eax
80100ff4:	83 f8 01             	cmp    $0x1,%eax
80100ff7:	0f 84 c2 00 00 00    	je     801010bf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100ffd:	83 f8 02             	cmp    $0x2,%eax
80101000:	0f 85 e4 00 00 00    	jne    801010ea <filewrite+0x11a>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101006:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101009:	31 ff                	xor    %edi,%edi
8010100b:	85 c0                	test   %eax,%eax
8010100d:	7f 34                	jg     80101043 <filewrite+0x73>
8010100f:	e9 9c 00 00 00       	jmp    801010b0 <filewrite+0xe0>
80101014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101018:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010101b:	83 ec 0c             	sub    $0xc,%esp
8010101e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101021:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101024:	e8 27 07 00 00       	call   80101750 <iunlock>
      end_op();
80101029:	e8 b2 1b 00 00       	call   80102be0 <end_op>
8010102e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101031:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101034:	39 d8                	cmp    %ebx,%eax
80101036:	0f 85 a1 00 00 00    	jne    801010dd <filewrite+0x10d>
        panic("short filewrite");
      i += r;
8010103c:	01 c7                	add    %eax,%edi
    while(i < n){
8010103e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101041:	7e 6d                	jle    801010b0 <filewrite+0xe0>
      int n1 = n - i;
80101043:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101046:	b8 00 06 00 00       	mov    $0x600,%eax
8010104b:	29 fb                	sub    %edi,%ebx
8010104d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101053:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101056:	e8 15 1b 00 00       	call   80102b70 <begin_op>
      ilock(f->ip);
8010105b:	83 ec 0c             	sub    $0xc,%esp
8010105e:	ff 76 10             	pushl  0x10(%esi)
80101061:	e8 0a 06 00 00       	call   80101670 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101066:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101069:	53                   	push   %ebx
8010106a:	ff 76 14             	pushl  0x14(%esi)
8010106d:	01 f8                	add    %edi,%eax
8010106f:	50                   	push   %eax
80101070:	ff 76 10             	pushl  0x10(%esi)
80101073:	e8 d8 09 00 00       	call   80101a50 <writei>
80101078:	83 c4 20             	add    $0x20,%esp
8010107b:	85 c0                	test   %eax,%eax
8010107d:	7f 99                	jg     80101018 <filewrite+0x48>
      iunlock(f->ip);
8010107f:	83 ec 0c             	sub    $0xc,%esp
80101082:	ff 76 10             	pushl  0x10(%esi)
80101085:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101088:	e8 c3 06 00 00       	call   80101750 <iunlock>
      end_op();
8010108d:	e8 4e 1b 00 00       	call   80102be0 <end_op>
      if(r < 0)
80101092:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101095:	83 c4 10             	add    $0x10,%esp
80101098:	85 c0                	test   %eax,%eax
8010109a:	74 98                	je     80101034 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010109c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010109f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010a4:	5b                   	pop    %ebx
801010a5:	5e                   	pop    %esi
801010a6:	5f                   	pop    %edi
801010a7:	5d                   	pop    %ebp
801010a8:	c3                   	ret    
801010a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010b0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010b3:	75 e7                	jne    8010109c <filewrite+0xcc>
}
801010b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010b8:	89 f8                	mov    %edi,%eax
801010ba:	5b                   	pop    %ebx
801010bb:	5e                   	pop    %esi
801010bc:	5f                   	pop    %edi
801010bd:	5d                   	pop    %ebp
801010be:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801010bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010c2:	89 45 10             	mov    %eax,0x10(%ebp)
801010c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010c8:	89 45 0c             	mov    %eax,0xc(%ebp)
801010cb:	8b 46 0c             	mov    0xc(%esi),%eax
801010ce:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d4:	5b                   	pop    %ebx
801010d5:	5e                   	pop    %esi
801010d6:	5f                   	pop    %edi
801010d7:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010d8:	e9 c3 22 00 00       	jmp    801033a0 <pipewrite>
        panic("short filewrite");
801010dd:	83 ec 0c             	sub    $0xc,%esp
801010e0:	68 ef 6f 10 80       	push   $0x80106fef
801010e5:	e8 86 f2 ff ff       	call   80100370 <panic>
  panic("filewrite");
801010ea:	83 ec 0c             	sub    $0xc,%esp
801010ed:	68 f5 6f 10 80       	push   $0x80106ff5
801010f2:	e8 79 f2 ff ff       	call   80100370 <panic>
801010f7:	66 90                	xchg   %ax,%ax
801010f9:	66 90                	xchg   %ax,%ax
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101109:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010110f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101112:	85 c9                	test   %ecx,%ecx
80101114:	0f 84 87 00 00 00    	je     801011a1 <balloc+0xa1>
8010111a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101121:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101124:	83 ec 08             	sub    $0x8,%esp
80101127:	89 f0                	mov    %esi,%eax
80101129:	c1 f8 0c             	sar    $0xc,%eax
8010112c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101132:	50                   	push   %eax
80101133:	ff 75 d8             	pushl  -0x28(%ebp)
80101136:	e8 95 ef ff ff       	call   801000d0 <bread>
8010113b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010113e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101143:	83 c4 10             	add    $0x10,%esp
80101146:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101149:	31 c0                	xor    %eax,%eax
8010114b:	eb 2f                	jmp    8010117c <balloc+0x7c>
8010114d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101150:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101152:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101155:	bb 01 00 00 00       	mov    $0x1,%ebx
8010115a:	83 e1 07             	and    $0x7,%ecx
8010115d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010115f:	89 c1                	mov    %eax,%ecx
80101161:	c1 f9 03             	sar    $0x3,%ecx
80101164:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101169:	85 df                	test   %ebx,%edi
8010116b:	89 fa                	mov    %edi,%edx
8010116d:	74 41                	je     801011b0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010116f:	83 c0 01             	add    $0x1,%eax
80101172:	83 c6 01             	add    $0x1,%esi
80101175:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010117a:	74 05                	je     80101181 <balloc+0x81>
8010117c:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010117f:	72 cf                	jb     80101150 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101181:	83 ec 0c             	sub    $0xc,%esp
80101184:	ff 75 e4             	pushl  -0x1c(%ebp)
80101187:	e8 54 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010118c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101193:	83 c4 10             	add    $0x10,%esp
80101196:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101199:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010119f:	77 80                	ja     80101121 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011a1:	83 ec 0c             	sub    $0xc,%esp
801011a4:	68 ff 6f 10 80       	push   $0x80106fff
801011a9:	e8 c2 f1 ff ff       	call   80100370 <panic>
801011ae:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011b3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011b6:	09 da                	or     %ebx,%edx
801011b8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011bc:	57                   	push   %edi
801011bd:	e8 8e 1b 00 00       	call   80102d50 <log_write>
        brelse(bp);
801011c2:	89 3c 24             	mov    %edi,(%esp)
801011c5:	e8 16 f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011ca:	58                   	pop    %eax
801011cb:	5a                   	pop    %edx
801011cc:	56                   	push   %esi
801011cd:	ff 75 d8             	pushl  -0x28(%ebp)
801011d0:	e8 fb ee ff ff       	call   801000d0 <bread>
801011d5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011da:	83 c4 0c             	add    $0xc,%esp
801011dd:	68 00 02 00 00       	push   $0x200
801011e2:	6a 00                	push   $0x0
801011e4:	50                   	push   %eax
801011e5:	e8 56 32 00 00       	call   80104440 <memset>
  log_write(bp);
801011ea:	89 1c 24             	mov    %ebx,(%esp)
801011ed:	e8 5e 1b 00 00       	call   80102d50 <log_write>
  brelse(bp);
801011f2:	89 1c 24             	mov    %ebx,(%esp)
801011f5:	e8 e6 ef ff ff       	call   801001e0 <brelse>
}
801011fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011fd:	89 f0                	mov    %esi,%eax
801011ff:	5b                   	pop    %ebx
80101200:	5e                   	pop    %esi
80101201:	5f                   	pop    %edi
80101202:	5d                   	pop    %ebp
80101203:	c3                   	ret    
80101204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010120a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101210 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101218:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010121a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010121f:	83 ec 28             	sub    $0x28,%esp
80101222:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101225:	68 e0 09 11 80       	push   $0x801109e0
8010122a:	e8 a1 30 00 00       	call   801042d0 <acquire>
8010122f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101232:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101235:	eb 1b                	jmp    80101252 <iget+0x42>
80101237:	89 f6                	mov    %esi,%esi
80101239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101240:	85 f6                	test   %esi,%esi
80101242:	74 44                	je     80101288 <iget+0x78>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101244:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010124a:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101250:	73 4e                	jae    801012a0 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101252:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101255:	85 c9                	test   %ecx,%ecx
80101257:	7e e7                	jle    80101240 <iget+0x30>
80101259:	39 3b                	cmp    %edi,(%ebx)
8010125b:	75 e3                	jne    80101240 <iget+0x30>
8010125d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101260:	75 de                	jne    80101240 <iget+0x30>
      release(&icache.lock);
80101262:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101265:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101268:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010126a:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
8010126f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101272:	e8 79 31 00 00       	call   801043f0 <release>
      return ip;
80101277:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101288:	85 c9                	test   %ecx,%ecx
8010128a:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101293:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101299:	72 b7                	jb     80101252 <iget+0x42>
8010129b:	90                   	nop
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(empty == 0)
801012a0:	85 f6                	test   %esi,%esi
801012a2:	74 2d                	je     801012d1 <iget+0xc1>
  release(&icache.lock);
801012a4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012a7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012a9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012ac:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012b3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012ba:	68 e0 09 11 80       	push   $0x801109e0
801012bf:	e8 2c 31 00 00       	call   801043f0 <release>
  return ip;
801012c4:	83 c4 10             	add    $0x10,%esp
}
801012c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ca:	89 f0                	mov    %esi,%eax
801012cc:	5b                   	pop    %ebx
801012cd:	5e                   	pop    %esi
801012ce:	5f                   	pop    %edi
801012cf:	5d                   	pop    %ebp
801012d0:	c3                   	ret    
    panic("iget: no inodes");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 15 70 10 80       	push   $0x80107015
801012d9:	e8 92 f0 ff ff       	call   80100370 <panic>
801012de:	66 90                	xchg   %ax,%ax

801012e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	89 c6                	mov    %eax,%esi
801012e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012eb:	83 fa 0b             	cmp    $0xb,%edx
801012ee:	77 18                	ja     80101308 <bmap+0x28>
801012f0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801012f3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801012f6:	85 db                	test   %ebx,%ebx
801012f8:	74 76                	je     80101370 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012fd:	89 d8                	mov    %ebx,%eax
801012ff:	5b                   	pop    %ebx
80101300:	5e                   	pop    %esi
80101301:	5f                   	pop    %edi
80101302:	5d                   	pop    %ebp
80101303:	c3                   	ret    
80101304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101308:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010130b:	83 fb 7f             	cmp    $0x7f,%ebx
8010130e:	0f 87 8e 00 00 00    	ja     801013a2 <bmap+0xc2>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101314:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010131a:	85 c0                	test   %eax,%eax
8010131c:	74 72                	je     80101390 <bmap+0xb0>
    bp = bread(ip->dev, addr);
8010131e:	83 ec 08             	sub    $0x8,%esp
80101321:	50                   	push   %eax
80101322:	ff 36                	pushl  (%esi)
80101324:	e8 a7 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
80101329:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010132d:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101330:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101332:	8b 1a                	mov    (%edx),%ebx
80101334:	85 db                	test   %ebx,%ebx
80101336:	75 1d                	jne    80101355 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101338:	8b 06                	mov    (%esi),%eax
8010133a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010133d:	e8 be fd ff ff       	call   80101100 <balloc>
80101342:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101345:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101348:	89 c3                	mov    %eax,%ebx
8010134a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010134c:	57                   	push   %edi
8010134d:	e8 fe 19 00 00       	call   80102d50 <log_write>
80101352:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101355:	83 ec 0c             	sub    $0xc,%esp
80101358:	57                   	push   %edi
80101359:	e8 82 ee ff ff       	call   801001e0 <brelse>
8010135e:	83 c4 10             	add    $0x10,%esp
}
80101361:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101364:	89 d8                	mov    %ebx,%eax
80101366:	5b                   	pop    %ebx
80101367:	5e                   	pop    %esi
80101368:	5f                   	pop    %edi
80101369:	5d                   	pop    %ebp
8010136a:	c3                   	ret    
8010136b:	90                   	nop
8010136c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101370:	8b 00                	mov    (%eax),%eax
80101372:	e8 89 fd ff ff       	call   80101100 <balloc>
80101377:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010137d:	89 c3                	mov    %eax,%ebx
}
8010137f:	89 d8                	mov    %ebx,%eax
80101381:	5b                   	pop    %ebx
80101382:	5e                   	pop    %esi
80101383:	5f                   	pop    %edi
80101384:	5d                   	pop    %ebp
80101385:	c3                   	ret    
80101386:	8d 76 00             	lea    0x0(%esi),%esi
80101389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101390:	8b 06                	mov    (%esi),%eax
80101392:	e8 69 fd ff ff       	call   80101100 <balloc>
80101397:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010139d:	e9 7c ff ff ff       	jmp    8010131e <bmap+0x3e>
  panic("bmap: out of range");
801013a2:	83 ec 0c             	sub    $0xc,%esp
801013a5:	68 25 70 10 80       	push   $0x80107025
801013aa:	e8 c1 ef ff ff       	call   80100370 <panic>
801013af:	90                   	nop

801013b0 <readsb>:
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	56                   	push   %esi
801013b4:	53                   	push   %ebx
801013b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013b8:	83 ec 08             	sub    $0x8,%esp
801013bb:	6a 01                	push   $0x1
801013bd:	ff 75 08             	pushl  0x8(%ebp)
801013c0:	e8 0b ed ff ff       	call   801000d0 <bread>
801013c5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013c7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ca:	83 c4 0c             	add    $0xc,%esp
801013cd:	6a 1c                	push   $0x1c
801013cf:	50                   	push   %eax
801013d0:	56                   	push   %esi
801013d1:	e8 1a 31 00 00       	call   801044f0 <memmove>
  brelse(bp);
801013d6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013d9:	83 c4 10             	add    $0x10,%esp
}
801013dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013df:	5b                   	pop    %ebx
801013e0:	5e                   	pop    %esi
801013e1:	5d                   	pop    %ebp
  brelse(bp);
801013e2:	e9 f9 ed ff ff       	jmp    801001e0 <brelse>
801013e7:	89 f6                	mov    %esi,%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013f0 <bfree>:
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	56                   	push   %esi
801013f4:	53                   	push   %ebx
801013f5:	89 d3                	mov    %edx,%ebx
801013f7:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
801013f9:	83 ec 08             	sub    $0x8,%esp
801013fc:	68 c0 09 11 80       	push   $0x801109c0
80101401:	50                   	push   %eax
80101402:	e8 a9 ff ff ff       	call   801013b0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101407:	58                   	pop    %eax
80101408:	5a                   	pop    %edx
80101409:	89 da                	mov    %ebx,%edx
8010140b:	c1 ea 0c             	shr    $0xc,%edx
8010140e:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101414:	52                   	push   %edx
80101415:	56                   	push   %esi
80101416:	e8 b5 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010141b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010141d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101420:	ba 01 00 00 00       	mov    $0x1,%edx
80101425:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101428:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010142e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101431:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101433:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101438:	85 d1                	test   %edx,%ecx
8010143a:	74 25                	je     80101461 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010143c:	f7 d2                	not    %edx
8010143e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101440:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101443:	21 ca                	and    %ecx,%edx
80101445:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101449:	56                   	push   %esi
8010144a:	e8 01 19 00 00       	call   80102d50 <log_write>
  brelse(bp);
8010144f:	89 34 24             	mov    %esi,(%esp)
80101452:	e8 89 ed ff ff       	call   801001e0 <brelse>
}
80101457:	83 c4 10             	add    $0x10,%esp
8010145a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010145d:	5b                   	pop    %ebx
8010145e:	5e                   	pop    %esi
8010145f:	5d                   	pop    %ebp
80101460:	c3                   	ret    
    panic("freeing free block");
80101461:	83 ec 0c             	sub    $0xc,%esp
80101464:	68 38 70 10 80       	push   $0x80107038
80101469:	e8 02 ef ff ff       	call   80100370 <panic>
8010146e:	66 90                	xchg   %ax,%ax

80101470 <iinit>:
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101479:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010147c:	68 4b 70 10 80       	push   $0x8010704b
80101481:	68 e0 09 11 80       	push   $0x801109e0
80101486:	e8 45 2d 00 00       	call   801041d0 <initlock>
8010148b:	83 c4 10             	add    $0x10,%esp
8010148e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101490:	83 ec 08             	sub    $0x8,%esp
80101493:	68 52 70 10 80       	push   $0x80107052
80101498:	53                   	push   %ebx
80101499:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010149f:	e8 1c 2c 00 00       	call   801040c0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014a4:	83 c4 10             	add    $0x10,%esp
801014a7:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014ad:	75 e1                	jne    80101490 <iinit+0x20>
  readsb(dev, &sb);
801014af:	83 ec 08             	sub    $0x8,%esp
801014b2:	68 c0 09 11 80       	push   $0x801109c0
801014b7:	ff 75 08             	pushl  0x8(%ebp)
801014ba:	e8 f1 fe ff ff       	call   801013b0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014bf:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014c5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014cb:	ff 35 d0 09 11 80    	pushl  0x801109d0
801014d1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801014d7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801014dd:	ff 35 c4 09 11 80    	pushl  0x801109c4
801014e3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801014e9:	68 b8 70 10 80       	push   $0x801070b8
801014ee:	e8 6d f1 ff ff       	call   80100660 <cprintf>
}
801014f3:	83 c4 30             	add    $0x30,%esp
801014f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014f9:	c9                   	leave  
801014fa:	c3                   	ret    
801014fb:	90                   	nop
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <ialloc>:
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	57                   	push   %edi
80101504:	56                   	push   %esi
80101505:	53                   	push   %ebx
80101506:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101509:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101510:	8b 45 0c             	mov    0xc(%ebp),%eax
80101513:	8b 75 08             	mov    0x8(%ebp),%esi
80101516:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	0f 86 91 00 00 00    	jbe    801015b0 <ialloc+0xb0>
8010151f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101524:	eb 21                	jmp    80101547 <ialloc+0x47>
80101526:	8d 76 00             	lea    0x0(%esi),%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101530:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101533:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101536:	57                   	push   %edi
80101537:	e8 a4 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010153c:	83 c4 10             	add    $0x10,%esp
8010153f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101545:	76 69                	jbe    801015b0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101547:	89 d8                	mov    %ebx,%eax
80101549:	83 ec 08             	sub    $0x8,%esp
8010154c:	c1 e8 03             	shr    $0x3,%eax
8010154f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101555:	50                   	push   %eax
80101556:	56                   	push   %esi
80101557:	e8 74 eb ff ff       	call   801000d0 <bread>
8010155c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010155e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101560:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101563:	83 e0 07             	and    $0x7,%eax
80101566:	c1 e0 06             	shl    $0x6,%eax
80101569:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010156d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101571:	75 bd                	jne    80101530 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101573:	83 ec 04             	sub    $0x4,%esp
80101576:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101579:	6a 40                	push   $0x40
8010157b:	6a 00                	push   $0x0
8010157d:	51                   	push   %ecx
8010157e:	e8 bd 2e 00 00       	call   80104440 <memset>
      dip->type = type;
80101583:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101587:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010158a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010158d:	89 3c 24             	mov    %edi,(%esp)
80101590:	e8 bb 17 00 00       	call   80102d50 <log_write>
      brelse(bp);
80101595:	89 3c 24             	mov    %edi,(%esp)
80101598:	e8 43 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010159d:	83 c4 10             	add    $0x10,%esp
}
801015a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015a3:	89 da                	mov    %ebx,%edx
801015a5:	89 f0                	mov    %esi,%eax
}
801015a7:	5b                   	pop    %ebx
801015a8:	5e                   	pop    %esi
801015a9:	5f                   	pop    %edi
801015aa:	5d                   	pop    %ebp
      return iget(dev, inum);
801015ab:	e9 60 fc ff ff       	jmp    80101210 <iget>
  panic("ialloc: no inodes");
801015b0:	83 ec 0c             	sub    $0xc,%esp
801015b3:	68 58 70 10 80       	push   $0x80107058
801015b8:	e8 b3 ed ff ff       	call   80100370 <panic>
801015bd:	8d 76 00             	lea    0x0(%esi),%esi

801015c0 <iupdate>:
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	56                   	push   %esi
801015c4:	53                   	push   %ebx
801015c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015c8:	83 ec 08             	sub    $0x8,%esp
801015cb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ce:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d1:	c1 e8 03             	shr    $0x3,%eax
801015d4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015da:	50                   	push   %eax
801015db:	ff 73 a4             	pushl  -0x5c(%ebx)
801015de:	e8 ed ea ff ff       	call   801000d0 <bread>
801015e3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015e5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015e8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ec:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ef:	83 e0 07             	and    $0x7,%eax
801015f2:	c1 e0 06             	shl    $0x6,%eax
801015f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015f9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015fc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101600:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101603:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101607:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010160b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010160f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101613:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101617:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010161a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161d:	6a 34                	push   $0x34
8010161f:	53                   	push   %ebx
80101620:	50                   	push   %eax
80101621:	e8 ca 2e 00 00       	call   801044f0 <memmove>
  log_write(bp);
80101626:	89 34 24             	mov    %esi,(%esp)
80101629:	e8 22 17 00 00       	call   80102d50 <log_write>
  brelse(bp);
8010162e:	89 75 08             	mov    %esi,0x8(%ebp)
80101631:	83 c4 10             	add    $0x10,%esp
}
80101634:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101637:	5b                   	pop    %ebx
80101638:	5e                   	pop    %esi
80101639:	5d                   	pop    %ebp
  brelse(bp);
8010163a:	e9 a1 eb ff ff       	jmp    801001e0 <brelse>
8010163f:	90                   	nop

80101640 <idup>:
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	53                   	push   %ebx
80101644:	83 ec 10             	sub    $0x10,%esp
80101647:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010164a:	68 e0 09 11 80       	push   $0x801109e0
8010164f:	e8 7c 2c 00 00       	call   801042d0 <acquire>
  ip->ref++;
80101654:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101658:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010165f:	e8 8c 2d 00 00       	call   801043f0 <release>
}
80101664:	89 d8                	mov    %ebx,%eax
80101666:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101669:	c9                   	leave  
8010166a:	c3                   	ret    
8010166b:	90                   	nop
8010166c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101670 <ilock>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	56                   	push   %esi
80101674:	53                   	push   %ebx
80101675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101678:	85 db                	test   %ebx,%ebx
8010167a:	0f 84 b7 00 00 00    	je     80101737 <ilock+0xc7>
80101680:	8b 53 08             	mov    0x8(%ebx),%edx
80101683:	85 d2                	test   %edx,%edx
80101685:	0f 8e ac 00 00 00    	jle    80101737 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010168b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010168e:	83 ec 0c             	sub    $0xc,%esp
80101691:	50                   	push   %eax
80101692:	e8 69 2a 00 00       	call   80104100 <acquiresleep>
  if(ip->valid == 0){
80101697:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010169a:	83 c4 10             	add    $0x10,%esp
8010169d:	85 c0                	test   %eax,%eax
8010169f:	74 0f                	je     801016b0 <ilock+0x40>
}
801016a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016a4:	5b                   	pop    %ebx
801016a5:	5e                   	pop    %esi
801016a6:	5d                   	pop    %ebp
801016a7:	c3                   	ret    
801016a8:	90                   	nop
801016a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b0:	8b 43 04             	mov    0x4(%ebx),%eax
801016b3:	83 ec 08             	sub    $0x8,%esp
801016b6:	c1 e8 03             	shr    $0x3,%eax
801016b9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016bf:	50                   	push   %eax
801016c0:	ff 33                	pushl  (%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
801016c7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016c9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016cc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016cf:	83 e0 07             	and    $0x7,%eax
801016d2:	c1 e0 06             	shl    $0x6,%eax
801016d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016d9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801016fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	50                   	push   %eax
80101704:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101707:	50                   	push   %eax
80101708:	e8 e3 2d 00 00       	call   801044f0 <memmove>
    brelse(bp);
8010170d:	89 34 24             	mov    %esi,(%esp)
80101710:	e8 cb ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101715:	83 c4 10             	add    $0x10,%esp
80101718:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010171d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101724:	0f 85 77 ff ff ff    	jne    801016a1 <ilock+0x31>
      panic("ilock: no type");
8010172a:	83 ec 0c             	sub    $0xc,%esp
8010172d:	68 70 70 10 80       	push   $0x80107070
80101732:	e8 39 ec ff ff       	call   80100370 <panic>
    panic("ilock");
80101737:	83 ec 0c             	sub    $0xc,%esp
8010173a:	68 6a 70 10 80       	push   $0x8010706a
8010173f:	e8 2c ec ff ff       	call   80100370 <panic>
80101744:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010174a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101750 <iunlock>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	56                   	push   %esi
80101754:	53                   	push   %ebx
80101755:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101758:	85 db                	test   %ebx,%ebx
8010175a:	74 28                	je     80101784 <iunlock+0x34>
8010175c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010175f:	83 ec 0c             	sub    $0xc,%esp
80101762:	56                   	push   %esi
80101763:	e8 38 2a 00 00       	call   801041a0 <holdingsleep>
80101768:	83 c4 10             	add    $0x10,%esp
8010176b:	85 c0                	test   %eax,%eax
8010176d:	74 15                	je     80101784 <iunlock+0x34>
8010176f:	8b 43 08             	mov    0x8(%ebx),%eax
80101772:	85 c0                	test   %eax,%eax
80101774:	7e 0e                	jle    80101784 <iunlock+0x34>
  releasesleep(&ip->lock);
80101776:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101779:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010177c:	5b                   	pop    %ebx
8010177d:	5e                   	pop    %esi
8010177e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010177f:	e9 dc 29 00 00       	jmp    80104160 <releasesleep>
    panic("iunlock");
80101784:	83 ec 0c             	sub    $0xc,%esp
80101787:	68 7f 70 10 80       	push   $0x8010707f
8010178c:	e8 df eb ff ff       	call   80100370 <panic>
80101791:	eb 0d                	jmp    801017a0 <iput>
80101793:	90                   	nop
80101794:	90                   	nop
80101795:	90                   	nop
80101796:	90                   	nop
80101797:	90                   	nop
80101798:	90                   	nop
80101799:	90                   	nop
8010179a:	90                   	nop
8010179b:	90                   	nop
8010179c:	90                   	nop
8010179d:	90                   	nop
8010179e:	90                   	nop
8010179f:	90                   	nop

801017a0 <iput>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	57                   	push   %edi
801017a4:	56                   	push   %esi
801017a5:	53                   	push   %ebx
801017a6:	83 ec 28             	sub    $0x28,%esp
801017a9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017ac:	8d 7e 0c             	lea    0xc(%esi),%edi
801017af:	57                   	push   %edi
801017b0:	e8 4b 29 00 00       	call   80104100 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017b5:	8b 56 4c             	mov    0x4c(%esi),%edx
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	85 d2                	test   %edx,%edx
801017bd:	74 07                	je     801017c6 <iput+0x26>
801017bf:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017c4:	74 32                	je     801017f8 <iput+0x58>
  releasesleep(&ip->lock);
801017c6:	83 ec 0c             	sub    $0xc,%esp
801017c9:	57                   	push   %edi
801017ca:	e8 91 29 00 00       	call   80104160 <releasesleep>
  acquire(&icache.lock);
801017cf:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017d6:	e8 f5 2a 00 00       	call   801042d0 <acquire>
  ip->ref--;
801017db:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017df:	83 c4 10             	add    $0x10,%esp
801017e2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801017e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017ec:	5b                   	pop    %ebx
801017ed:	5e                   	pop    %esi
801017ee:	5f                   	pop    %edi
801017ef:	5d                   	pop    %ebp
  release(&icache.lock);
801017f0:	e9 fb 2b 00 00       	jmp    801043f0 <release>
801017f5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801017f8:	83 ec 0c             	sub    $0xc,%esp
801017fb:	68 e0 09 11 80       	push   $0x801109e0
80101800:	e8 cb 2a 00 00       	call   801042d0 <acquire>
    int r = ip->ref;
80101805:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101808:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010180f:	e8 dc 2b 00 00       	call   801043f0 <release>
    if(r == 1){
80101814:	83 c4 10             	add    $0x10,%esp
80101817:	83 fb 01             	cmp    $0x1,%ebx
8010181a:	75 aa                	jne    801017c6 <iput+0x26>
8010181c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101822:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101825:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101828:	89 cf                	mov    %ecx,%edi
8010182a:	eb 0b                	jmp    80101837 <iput+0x97>
8010182c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101830:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101833:	39 fb                	cmp    %edi,%ebx
80101835:	74 19                	je     80101850 <iput+0xb0>
    if(ip->addrs[i]){
80101837:	8b 13                	mov    (%ebx),%edx
80101839:	85 d2                	test   %edx,%edx
8010183b:	74 f3                	je     80101830 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010183d:	8b 06                	mov    (%esi),%eax
8010183f:	e8 ac fb ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101844:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010184a:	eb e4                	jmp    80101830 <iput+0x90>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101850:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101856:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101859:	85 c0                	test   %eax,%eax
8010185b:	75 33                	jne    80101890 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010185d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101860:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101867:	56                   	push   %esi
80101868:	e8 53 fd ff ff       	call   801015c0 <iupdate>
      ip->type = 0;
8010186d:	31 c0                	xor    %eax,%eax
8010186f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101873:	89 34 24             	mov    %esi,(%esp)
80101876:	e8 45 fd ff ff       	call   801015c0 <iupdate>
      ip->valid = 0;
8010187b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101882:	83 c4 10             	add    $0x10,%esp
80101885:	e9 3c ff ff ff       	jmp    801017c6 <iput+0x26>
8010188a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101890:	83 ec 08             	sub    $0x8,%esp
80101893:	50                   	push   %eax
80101894:	ff 36                	pushl  (%esi)
80101896:	e8 35 e8 ff ff       	call   801000d0 <bread>
8010189b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018a1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018a7:	8d 58 5c             	lea    0x5c(%eax),%ebx
801018aa:	83 c4 10             	add    $0x10,%esp
801018ad:	89 cf                	mov    %ecx,%edi
801018af:	eb 0e                	jmp    801018bf <iput+0x11f>
801018b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018b8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801018bb:	39 fb                	cmp    %edi,%ebx
801018bd:	74 0f                	je     801018ce <iput+0x12e>
      if(a[j])
801018bf:	8b 13                	mov    (%ebx),%edx
801018c1:	85 d2                	test   %edx,%edx
801018c3:	74 f3                	je     801018b8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018c5:	8b 06                	mov    (%esi),%eax
801018c7:	e8 24 fb ff ff       	call   801013f0 <bfree>
801018cc:	eb ea                	jmp    801018b8 <iput+0x118>
    brelse(bp);
801018ce:	83 ec 0c             	sub    $0xc,%esp
801018d1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018d4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018d7:	e8 04 e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018dc:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018e2:	8b 06                	mov    (%esi),%eax
801018e4:	e8 07 fb ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018e9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018f0:	00 00 00 
801018f3:	83 c4 10             	add    $0x10,%esp
801018f6:	e9 62 ff ff ff       	jmp    8010185d <iput+0xbd>
801018fb:	90                   	nop
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101900 <iunlockput>:
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	53                   	push   %ebx
80101904:	83 ec 10             	sub    $0x10,%esp
80101907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010190a:	53                   	push   %ebx
8010190b:	e8 40 fe ff ff       	call   80101750 <iunlock>
  iput(ip);
80101910:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101913:	83 c4 10             	add    $0x10,%esp
}
80101916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101919:	c9                   	leave  
  iput(ip);
8010191a:	e9 81 fe ff ff       	jmp    801017a0 <iput>
8010191f:	90                   	nop

80101920 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	8b 55 08             	mov    0x8(%ebp),%edx
80101926:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101929:	8b 0a                	mov    (%edx),%ecx
8010192b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010192e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101931:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101934:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101938:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010193b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010193f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101943:	8b 52 58             	mov    0x58(%edx),%edx
80101946:	89 50 10             	mov    %edx,0x10(%eax)
}
80101949:	5d                   	pop    %ebp
8010194a:	c3                   	ret    
8010194b:	90                   	nop
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	57                   	push   %edi
80101954:	56                   	push   %esi
80101955:	53                   	push   %ebx
80101956:	83 ec 1c             	sub    $0x1c,%esp
80101959:	8b 45 08             	mov    0x8(%ebp),%eax
8010195c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010195f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101962:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101967:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010196a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010196d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101970:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101973:	0f 84 a7 00 00 00    	je     80101a20 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101979:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010197c:	8b 40 58             	mov    0x58(%eax),%eax
8010197f:	39 f0                	cmp    %esi,%eax
80101981:	0f 82 ba 00 00 00    	jb     80101a41 <readi+0xf1>
80101987:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010198a:	89 f9                	mov    %edi,%ecx
8010198c:	01 f1                	add    %esi,%ecx
8010198e:	0f 82 ad 00 00 00    	jb     80101a41 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101994:	89 c2                	mov    %eax,%edx
80101996:	29 f2                	sub    %esi,%edx
80101998:	39 c8                	cmp    %ecx,%eax
8010199a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010199d:	31 ff                	xor    %edi,%edi
8010199f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019a1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019a4:	74 6c                	je     80101a12 <readi+0xc2>
801019a6:	8d 76 00             	lea    0x0(%esi),%esi
801019a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019b0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019b3:	89 f2                	mov    %esi,%edx
801019b5:	c1 ea 09             	shr    $0x9,%edx
801019b8:	89 d8                	mov    %ebx,%eax
801019ba:	e8 21 f9 ff ff       	call   801012e0 <bmap>
801019bf:	83 ec 08             	sub    $0x8,%esp
801019c2:	50                   	push   %eax
801019c3:	ff 33                	pushl  (%ebx)
801019c5:	e8 06 e7 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ca:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019cd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019cf:	89 f0                	mov    %esi,%eax
801019d1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019d6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019db:	83 c4 0c             	add    $0xc,%esp
801019de:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801019e0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801019e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801019e7:	29 fb                	sub    %edi,%ebx
801019e9:	39 d9                	cmp    %ebx,%ecx
801019eb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019ee:	53                   	push   %ebx
801019ef:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
801019f2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
801019f7:	e8 f4 2a 00 00       	call   801044f0 <memmove>
    brelse(bp);
801019fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019ff:	89 14 24             	mov    %edx,(%esp)
80101a02:	e8 d9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a07:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a0a:	83 c4 10             	add    $0x10,%esp
80101a0d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a10:	77 9e                	ja     801019b0 <readi+0x60>
  }
  return n;
80101a12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a18:	5b                   	pop    %ebx
80101a19:	5e                   	pop    %esi
80101a1a:	5f                   	pop    %edi
80101a1b:	5d                   	pop    %ebp
80101a1c:	c3                   	ret    
80101a1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a24:	66 83 f8 09          	cmp    $0x9,%ax
80101a28:	77 17                	ja     80101a41 <readi+0xf1>
80101a2a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a31:	85 c0                	test   %eax,%eax
80101a33:	74 0c                	je     80101a41 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a35:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a3b:	5b                   	pop    %ebx
80101a3c:	5e                   	pop    %esi
80101a3d:	5f                   	pop    %edi
80101a3e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a3f:	ff e0                	jmp    *%eax
      return -1;
80101a41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a46:	eb cd                	jmp    80101a15 <readi+0xc5>
80101a48:	90                   	nop
80101a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a50 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a50:	55                   	push   %ebp
80101a51:	89 e5                	mov    %esp,%ebp
80101a53:	57                   	push   %edi
80101a54:	56                   	push   %esi
80101a55:	53                   	push   %ebx
80101a56:	83 ec 1c             	sub    $0x1c,%esp
80101a59:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a5f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a67:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a6d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a70:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a73:	0f 84 b7 00 00 00    	je     80101b30 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a7c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a7f:	0f 82 eb 00 00 00    	jb     80101b70 <writei+0x120>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a85:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a88:	89 c8                	mov    %ecx,%eax
80101a8a:	01 f0                	add    %esi,%eax
80101a8c:	0f 82 de 00 00 00    	jb     80101b70 <writei+0x120>
80101a92:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a97:	0f 87 d3 00 00 00    	ja     80101b70 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a9d:	85 c9                	test   %ecx,%ecx
80101a9f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101aa6:	74 79                	je     80101b21 <writei+0xd1>
80101aa8:	90                   	nop
80101aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ab3:	89 f2                	mov    %esi,%edx
80101ab5:	c1 ea 09             	shr    $0x9,%edx
80101ab8:	89 f8                	mov    %edi,%eax
80101aba:	e8 21 f8 ff ff       	call   801012e0 <bmap>
80101abf:	83 ec 08             	sub    $0x8,%esp
80101ac2:	50                   	push   %eax
80101ac3:	ff 37                	pushl  (%edi)
80101ac5:	e8 06 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aca:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101acd:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ad2:	89 f0                	mov    %esi,%eax
80101ad4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ad9:	83 c4 0c             	add    $0xc,%esp
80101adc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ae1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ae3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae7:	39 d9                	cmp    %ebx,%ecx
80101ae9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101aec:	53                   	push   %ebx
80101aed:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101af2:	50                   	push   %eax
80101af3:	e8 f8 29 00 00       	call   801044f0 <memmove>
    log_write(bp);
80101af8:	89 3c 24             	mov    %edi,(%esp)
80101afb:	e8 50 12 00 00       	call   80102d50 <log_write>
    brelse(bp);
80101b00:	89 3c 24             	mov    %edi,(%esp)
80101b03:	e8 d8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b08:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b0b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b0e:	83 c4 10             	add    $0x10,%esp
80101b11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b14:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101b17:	77 97                	ja     80101ab0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b1f:	77 37                	ja     80101b58 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b21:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b24:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b27:	5b                   	pop    %ebx
80101b28:	5e                   	pop    %esi
80101b29:	5f                   	pop    %edi
80101b2a:	5d                   	pop    %ebp
80101b2b:	c3                   	ret    
80101b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 36                	ja     80101b70 <writei+0x120>
80101b3a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 2b                	je     80101b70 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b45:	89 4d 10             	mov    %ecx,0x10(%ebp)
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b4f:	ff e0                	jmp    *%eax
80101b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b58:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b5b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b5e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b61:	50                   	push   %eax
80101b62:	e8 59 fa ff ff       	call   801015c0 <iupdate>
80101b67:	83 c4 10             	add    $0x10,%esp
80101b6a:	eb b5                	jmp    80101b21 <writei+0xd1>
80101b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b75:	eb ad                	jmp    80101b24 <writei+0xd4>
80101b77:	89 f6                	mov    %esi,%esi
80101b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b80 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b86:	6a 0e                	push   $0xe
80101b88:	ff 75 0c             	pushl  0xc(%ebp)
80101b8b:	ff 75 08             	pushl  0x8(%ebp)
80101b8e:	e8 cd 29 00 00       	call   80104560 <strncmp>
}
80101b93:	c9                   	leave  
80101b94:	c3                   	ret    
80101b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bb1:	0f 85 80 00 00 00    	jne    80101c37 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bb7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bba:	31 ff                	xor    %edi,%edi
80101bbc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bbf:	85 d2                	test   %edx,%edx
80101bc1:	75 0d                	jne    80101bd0 <dirlookup+0x30>
80101bc3:	eb 5b                	jmp    80101c20 <dirlookup+0x80>
80101bc5:	8d 76 00             	lea    0x0(%esi),%esi
80101bc8:	83 c7 10             	add    $0x10,%edi
80101bcb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bce:	76 50                	jbe    80101c20 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd0:	6a 10                	push   $0x10
80101bd2:	57                   	push   %edi
80101bd3:	56                   	push   %esi
80101bd4:	53                   	push   %ebx
80101bd5:	e8 76 fd ff ff       	call   80101950 <readi>
80101bda:	83 c4 10             	add    $0x10,%esp
80101bdd:	83 f8 10             	cmp    $0x10,%eax
80101be0:	75 48                	jne    80101c2a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101be2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101be7:	74 df                	je     80101bc8 <dirlookup+0x28>
  return strncmp(s, t, DIRSIZ);
80101be9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bec:	83 ec 04             	sub    $0x4,%esp
80101bef:	6a 0e                	push   $0xe
80101bf1:	50                   	push   %eax
80101bf2:	ff 75 0c             	pushl  0xc(%ebp)
80101bf5:	e8 66 29 00 00       	call   80104560 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101bfa:	83 c4 10             	add    $0x10,%esp
80101bfd:	85 c0                	test   %eax,%eax
80101bff:	75 c7                	jne    80101bc8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c01:	8b 45 10             	mov    0x10(%ebp),%eax
80101c04:	85 c0                	test   %eax,%eax
80101c06:	74 05                	je     80101c0d <dirlookup+0x6d>
        *poff = off;
80101c08:	8b 45 10             	mov    0x10(%ebp),%eax
80101c0b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c0d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c11:	8b 03                	mov    (%ebx),%eax
80101c13:	e8 f8 f5 ff ff       	call   80101210 <iget>
    }
  }

  return 0;
}
80101c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c1b:	5b                   	pop    %ebx
80101c1c:	5e                   	pop    %esi
80101c1d:	5f                   	pop    %edi
80101c1e:	5d                   	pop    %ebp
80101c1f:	c3                   	ret    
80101c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c23:	31 c0                	xor    %eax,%eax
}
80101c25:	5b                   	pop    %ebx
80101c26:	5e                   	pop    %esi
80101c27:	5f                   	pop    %edi
80101c28:	5d                   	pop    %ebp
80101c29:	c3                   	ret    
      panic("dirlookup read");
80101c2a:	83 ec 0c             	sub    $0xc,%esp
80101c2d:	68 99 70 10 80       	push   $0x80107099
80101c32:	e8 39 e7 ff ff       	call   80100370 <panic>
    panic("dirlookup not DIR");
80101c37:	83 ec 0c             	sub    $0xc,%esp
80101c3a:	68 87 70 10 80       	push   $0x80107087
80101c3f:	e8 2c e7 ff ff       	call   80100370 <panic>
80101c44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c50 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	89 cf                	mov    %ecx,%edi
80101c58:	89 c3                	mov    %eax,%ebx
80101c5a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c5d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c60:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c63:	0f 84 55 01 00 00    	je     80101dbe <namex+0x16e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c69:	e8 22 1b 00 00       	call   80103790 <myproc>
  acquire(&icache.lock);
80101c6e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c71:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c74:	68 e0 09 11 80       	push   $0x801109e0
80101c79:	e8 52 26 00 00       	call   801042d0 <acquire>
  ip->ref++;
80101c7e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c82:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c89:	e8 62 27 00 00       	call   801043f0 <release>
80101c8e:	83 c4 10             	add    $0x10,%esp
80101c91:	eb 08                	jmp    80101c9b <namex+0x4b>
80101c93:	90                   	nop
80101c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101c98:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101c9b:	0f b6 03             	movzbl (%ebx),%eax
80101c9e:	3c 2f                	cmp    $0x2f,%al
80101ca0:	74 f6                	je     80101c98 <namex+0x48>
  if(*path == 0)
80101ca2:	84 c0                	test   %al,%al
80101ca4:	0f 84 e3 00 00 00    	je     80101d8d <namex+0x13d>
  while(*path != '/' && *path != 0)
80101caa:	0f b6 03             	movzbl (%ebx),%eax
80101cad:	89 da                	mov    %ebx,%edx
80101caf:	84 c0                	test   %al,%al
80101cb1:	0f 84 ac 00 00 00    	je     80101d63 <namex+0x113>
80101cb7:	3c 2f                	cmp    $0x2f,%al
80101cb9:	75 09                	jne    80101cc4 <namex+0x74>
80101cbb:	e9 a3 00 00 00       	jmp    80101d63 <namex+0x113>
80101cc0:	84 c0                	test   %al,%al
80101cc2:	74 0a                	je     80101cce <namex+0x7e>
    path++;
80101cc4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cc7:	0f b6 02             	movzbl (%edx),%eax
80101cca:	3c 2f                	cmp    $0x2f,%al
80101ccc:	75 f2                	jne    80101cc0 <namex+0x70>
80101cce:	89 d1                	mov    %edx,%ecx
80101cd0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101cd2:	83 f9 0d             	cmp    $0xd,%ecx
80101cd5:	0f 8e 8d 00 00 00    	jle    80101d68 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101cdb:	83 ec 04             	sub    $0x4,%esp
80101cde:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101ce1:	6a 0e                	push   $0xe
80101ce3:	53                   	push   %ebx
80101ce4:	57                   	push   %edi
80101ce5:	e8 06 28 00 00       	call   801044f0 <memmove>
    path++;
80101cea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101ced:	83 c4 10             	add    $0x10,%esp
    path++;
80101cf0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101cf2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101cf5:	75 11                	jne    80101d08 <namex+0xb8>
80101cf7:	89 f6                	mov    %esi,%esi
80101cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d00:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d03:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d06:	74 f8                	je     80101d00 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d08:	83 ec 0c             	sub    $0xc,%esp
80101d0b:	56                   	push   %esi
80101d0c:	e8 5f f9 ff ff       	call   80101670 <ilock>
    if(ip->type != T_DIR){
80101d11:	83 c4 10             	add    $0x10,%esp
80101d14:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d19:	0f 85 7f 00 00 00    	jne    80101d9e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d1f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d22:	85 d2                	test   %edx,%edx
80101d24:	74 09                	je     80101d2f <namex+0xdf>
80101d26:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d29:	0f 84 a5 00 00 00    	je     80101dd4 <namex+0x184>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d2f:	83 ec 04             	sub    $0x4,%esp
80101d32:	6a 00                	push   $0x0
80101d34:	57                   	push   %edi
80101d35:	56                   	push   %esi
80101d36:	e8 65 fe ff ff       	call   80101ba0 <dirlookup>
80101d3b:	83 c4 10             	add    $0x10,%esp
80101d3e:	85 c0                	test   %eax,%eax
80101d40:	74 5c                	je     80101d9e <namex+0x14e>
  iunlock(ip);
80101d42:	83 ec 0c             	sub    $0xc,%esp
80101d45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d48:	56                   	push   %esi
80101d49:	e8 02 fa ff ff       	call   80101750 <iunlock>
  iput(ip);
80101d4e:	89 34 24             	mov    %esi,(%esp)
80101d51:	e8 4a fa ff ff       	call   801017a0 <iput>
80101d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d59:	83 c4 10             	add    $0x10,%esp
80101d5c:	89 c6                	mov    %eax,%esi
80101d5e:	e9 38 ff ff ff       	jmp    80101c9b <namex+0x4b>
  while(*path != '/' && *path != 0)
80101d63:	31 c9                	xor    %ecx,%ecx
80101d65:	8d 76 00             	lea    0x0(%esi),%esi
    memmove(name, s, len);
80101d68:	83 ec 04             	sub    $0x4,%esp
80101d6b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d6e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d71:	51                   	push   %ecx
80101d72:	53                   	push   %ebx
80101d73:	57                   	push   %edi
80101d74:	e8 77 27 00 00       	call   801044f0 <memmove>
    name[len] = 0;
80101d79:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d7f:	83 c4 10             	add    $0x10,%esp
80101d82:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d86:	89 d3                	mov    %edx,%ebx
80101d88:	e9 65 ff ff ff       	jmp    80101cf2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d90:	85 c0                	test   %eax,%eax
80101d92:	75 56                	jne    80101dea <namex+0x19a>
    iput(ip);
    return 0;
  }
  return ip;
}
80101d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d97:	89 f0                	mov    %esi,%eax
80101d99:	5b                   	pop    %ebx
80101d9a:	5e                   	pop    %esi
80101d9b:	5f                   	pop    %edi
80101d9c:	5d                   	pop    %ebp
80101d9d:	c3                   	ret    
  iunlock(ip);
80101d9e:	83 ec 0c             	sub    $0xc,%esp
80101da1:	56                   	push   %esi
80101da2:	e8 a9 f9 ff ff       	call   80101750 <iunlock>
  iput(ip);
80101da7:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101daa:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dac:	e8 ef f9 ff ff       	call   801017a0 <iput>
      return 0;
80101db1:	83 c4 10             	add    $0x10,%esp
}
80101db4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db7:	89 f0                	mov    %esi,%eax
80101db9:	5b                   	pop    %ebx
80101dba:	5e                   	pop    %esi
80101dbb:	5f                   	pop    %edi
80101dbc:	5d                   	pop    %ebp
80101dbd:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101dbe:	ba 01 00 00 00       	mov    $0x1,%edx
80101dc3:	b8 01 00 00 00       	mov    $0x1,%eax
80101dc8:	e8 43 f4 ff ff       	call   80101210 <iget>
80101dcd:	89 c6                	mov    %eax,%esi
80101dcf:	e9 c7 fe ff ff       	jmp    80101c9b <namex+0x4b>
      iunlock(ip);
80101dd4:	83 ec 0c             	sub    $0xc,%esp
80101dd7:	56                   	push   %esi
80101dd8:	e8 73 f9 ff ff       	call   80101750 <iunlock>
      return ip;
80101ddd:	83 c4 10             	add    $0x10,%esp
}
80101de0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de3:	89 f0                	mov    %esi,%eax
80101de5:	5b                   	pop    %ebx
80101de6:	5e                   	pop    %esi
80101de7:	5f                   	pop    %edi
80101de8:	5d                   	pop    %ebp
80101de9:	c3                   	ret    
    iput(ip);
80101dea:	83 ec 0c             	sub    $0xc,%esp
80101ded:	56                   	push   %esi
    return 0;
80101dee:	31 f6                	xor    %esi,%esi
    iput(ip);
80101df0:	e8 ab f9 ff ff       	call   801017a0 <iput>
    return 0;
80101df5:	83 c4 10             	add    $0x10,%esp
80101df8:	eb 9a                	jmp    80101d94 <namex+0x144>
80101dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101e00 <dirlink>:
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	83 ec 20             	sub    $0x20,%esp
80101e09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e0c:	6a 00                	push   $0x0
80101e0e:	ff 75 0c             	pushl  0xc(%ebp)
80101e11:	53                   	push   %ebx
80101e12:	e8 89 fd ff ff       	call   80101ba0 <dirlookup>
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	85 c0                	test   %eax,%eax
80101e1c:	75 67                	jne    80101e85 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e1e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e21:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e24:	85 ff                	test   %edi,%edi
80101e26:	74 29                	je     80101e51 <dirlink+0x51>
80101e28:	31 ff                	xor    %edi,%edi
80101e2a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e2d:	eb 09                	jmp    80101e38 <dirlink+0x38>
80101e2f:	90                   	nop
80101e30:	83 c7 10             	add    $0x10,%edi
80101e33:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e36:	76 19                	jbe    80101e51 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e38:	6a 10                	push   $0x10
80101e3a:	57                   	push   %edi
80101e3b:	56                   	push   %esi
80101e3c:	53                   	push   %ebx
80101e3d:	e8 0e fb ff ff       	call   80101950 <readi>
80101e42:	83 c4 10             	add    $0x10,%esp
80101e45:	83 f8 10             	cmp    $0x10,%eax
80101e48:	75 4e                	jne    80101e98 <dirlink+0x98>
    if(de.inum == 0)
80101e4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e4f:	75 df                	jne    80101e30 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e51:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e54:	83 ec 04             	sub    $0x4,%esp
80101e57:	6a 0e                	push   $0xe
80101e59:	ff 75 0c             	pushl  0xc(%ebp)
80101e5c:	50                   	push   %eax
80101e5d:	e8 5e 27 00 00       	call   801045c0 <strncpy>
  de.inum = inum;
80101e62:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e65:	6a 10                	push   $0x10
80101e67:	57                   	push   %edi
80101e68:	56                   	push   %esi
80101e69:	53                   	push   %ebx
  de.inum = inum;
80101e6a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e6e:	e8 dd fb ff ff       	call   80101a50 <writei>
80101e73:	83 c4 20             	add    $0x20,%esp
80101e76:	83 f8 10             	cmp    $0x10,%eax
80101e79:	75 2a                	jne    80101ea5 <dirlink+0xa5>
  return 0;
80101e7b:	31 c0                	xor    %eax,%eax
}
80101e7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e80:	5b                   	pop    %ebx
80101e81:	5e                   	pop    %esi
80101e82:	5f                   	pop    %edi
80101e83:	5d                   	pop    %ebp
80101e84:	c3                   	ret    
    iput(ip);
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	50                   	push   %eax
80101e89:	e8 12 f9 ff ff       	call   801017a0 <iput>
    return -1;
80101e8e:	83 c4 10             	add    $0x10,%esp
80101e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e96:	eb e5                	jmp    80101e7d <dirlink+0x7d>
      panic("dirlink read");
80101e98:	83 ec 0c             	sub    $0xc,%esp
80101e9b:	68 a8 70 10 80       	push   $0x801070a8
80101ea0:	e8 cb e4 ff ff       	call   80100370 <panic>
    panic("dirlink");
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	68 a2 76 10 80       	push   $0x801076a2
80101ead:	e8 be e4 ff ff       	call   80100370 <panic>
80101eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ec0 <namei>:

struct inode*
namei(char *path)
{
80101ec0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ec1:	31 d2                	xor    %edx,%edx
{
80101ec3:	89 e5                	mov    %esp,%ebp
80101ec5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101ece:	e8 7d fd ff ff       	call   80101c50 <namex>
}
80101ed3:	c9                   	leave  
80101ed4:	c3                   	ret    
80101ed5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ee0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ee1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101ee6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101eeb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101eee:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101eef:	e9 5c fd ff ff       	jmp    80101c50 <namex>
80101ef4:	66 90                	xchg   %ax,%ax
80101ef6:	66 90                	xchg   %ax,%ax
80101ef8:	66 90                	xchg   %ax,%ax
80101efa:	66 90                	xchg   %ax,%ax
80101efc:	66 90                	xchg   %ax,%ax
80101efe:	66 90                	xchg   %ax,%ax

80101f00 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f00:	55                   	push   %ebp
  if(b == 0)
80101f01:	85 c0                	test   %eax,%eax
{
80101f03:	89 e5                	mov    %esp,%ebp
80101f05:	56                   	push   %esi
80101f06:	53                   	push   %ebx
  if(b == 0)
80101f07:	0f 84 ad 00 00 00    	je     80101fba <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f0d:	8b 58 08             	mov    0x8(%eax),%ebx
80101f10:	89 c1                	mov    %eax,%ecx
80101f12:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f18:	0f 87 8f 00 00 00    	ja     80101fad <idestart+0xad>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f1e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f23:	90                   	nop
80101f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f28:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f29:	83 e0 c0             	and    $0xffffffc0,%eax
80101f2c:	3c 40                	cmp    $0x40,%al
80101f2e:	75 f8                	jne    80101f28 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f30:	31 f6                	xor    %esi,%esi
80101f32:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f37:	89 f0                	mov    %esi,%eax
80101f39:	ee                   	out    %al,(%dx)
80101f3a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f3f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f44:	ee                   	out    %al,(%dx)
80101f45:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f4a:	89 d8                	mov    %ebx,%eax
80101f4c:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f4d:	89 d8                	mov    %ebx,%eax
80101f4f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f54:	c1 f8 08             	sar    $0x8,%eax
80101f57:	ee                   	out    %al,(%dx)
80101f58:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f5d:	89 f0                	mov    %esi,%eax
80101f5f:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f60:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101f64:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f69:	c1 e0 04             	shl    $0x4,%eax
80101f6c:	83 e0 10             	and    $0x10,%eax
80101f6f:	83 c8 e0             	or     $0xffffffe0,%eax
80101f72:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f73:	f6 01 04             	testb  $0x4,(%ecx)
80101f76:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f7b:	75 13                	jne    80101f90 <idestart+0x90>
80101f7d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f82:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f83:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f86:	5b                   	pop    %ebx
80101f87:	5e                   	pop    %esi
80101f88:	5d                   	pop    %ebp
80101f89:	c3                   	ret    
80101f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f90:	b8 30 00 00 00       	mov    $0x30,%eax
80101f95:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101f96:	ba f0 01 00 00       	mov    $0x1f0,%edx
    outsl(0x1f0, b->data, BSIZE/4);
80101f9b:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101f9e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101fa3:	fc                   	cld    
80101fa4:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fa6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101fa9:	5b                   	pop    %ebx
80101faa:	5e                   	pop    %esi
80101fab:	5d                   	pop    %ebp
80101fac:	c3                   	ret    
    panic("incorrect blockno");
80101fad:	83 ec 0c             	sub    $0xc,%esp
80101fb0:	68 14 71 10 80       	push   $0x80107114
80101fb5:	e8 b6 e3 ff ff       	call   80100370 <panic>
    panic("idestart");
80101fba:	83 ec 0c             	sub    $0xc,%esp
80101fbd:	68 0b 71 10 80       	push   $0x8010710b
80101fc2:	e8 a9 e3 ff ff       	call   80100370 <panic>
80101fc7:	89 f6                	mov    %esi,%esi
80101fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fd0 <ideinit>:
{
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101fd6:	68 26 71 10 80       	push   $0x80107126
80101fdb:	68 80 a5 10 80       	push   $0x8010a580
80101fe0:	e8 eb 21 00 00       	call   801041d0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101fe5:	58                   	pop    %eax
80101fe6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101feb:	5a                   	pop    %edx
80101fec:	83 e8 01             	sub    $0x1,%eax
80101fef:	50                   	push   %eax
80101ff0:	6a 0e                	push   $0xe
80101ff2:	e8 a9 02 00 00       	call   801022a0 <ioapicenable>
80101ff7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ffa:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fff:	90                   	nop
80102000:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102001:	83 e0 c0             	and    $0xffffffc0,%eax
80102004:	3c 40                	cmp    $0x40,%al
80102006:	75 f8                	jne    80102000 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102008:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010200d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102012:	ee                   	out    %al,(%dx)
80102013:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102018:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010201d:	eb 06                	jmp    80102025 <ideinit+0x55>
8010201f:	90                   	nop
  for(i=0; i<1000; i++){
80102020:	83 e9 01             	sub    $0x1,%ecx
80102023:	74 0f                	je     80102034 <ideinit+0x64>
80102025:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102026:	84 c0                	test   %al,%al
80102028:	74 f6                	je     80102020 <ideinit+0x50>
      havedisk1 = 1;
8010202a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102031:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102034:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102039:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010203e:	ee                   	out    %al,(%dx)
}
8010203f:	c9                   	leave  
80102040:	c3                   	ret    
80102041:	eb 0d                	jmp    80102050 <ideintr>
80102043:	90                   	nop
80102044:	90                   	nop
80102045:	90                   	nop
80102046:	90                   	nop
80102047:	90                   	nop
80102048:	90                   	nop
80102049:	90                   	nop
8010204a:	90                   	nop
8010204b:	90                   	nop
8010204c:	90                   	nop
8010204d:	90                   	nop
8010204e:	90                   	nop
8010204f:	90                   	nop

80102050 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	57                   	push   %edi
80102054:	56                   	push   %esi
80102055:	53                   	push   %ebx
80102056:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102059:	68 80 a5 10 80       	push   $0x8010a580
8010205e:	e8 6d 22 00 00       	call   801042d0 <acquire>

  if((b = idequeue) == 0){
80102063:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102069:	83 c4 10             	add    $0x10,%esp
8010206c:	85 db                	test   %ebx,%ebx
8010206e:	74 34                	je     801020a4 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102070:	8b 43 58             	mov    0x58(%ebx),%eax
80102073:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102078:	8b 33                	mov    (%ebx),%esi
8010207a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102080:	74 3e                	je     801020c0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102082:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102085:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102088:	83 ce 02             	or     $0x2,%esi
8010208b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010208d:	53                   	push   %ebx
8010208e:	e8 7d 1e 00 00       	call   80103f10 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102093:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102098:	83 c4 10             	add    $0x10,%esp
8010209b:	85 c0                	test   %eax,%eax
8010209d:	74 05                	je     801020a4 <ideintr+0x54>
    idestart(idequeue);
8010209f:	e8 5c fe ff ff       	call   80101f00 <idestart>
    release(&idelock);
801020a4:	83 ec 0c             	sub    $0xc,%esp
801020a7:	68 80 a5 10 80       	push   $0x8010a580
801020ac:	e8 3f 23 00 00       	call   801043f0 <release>

  release(&idelock);
}
801020b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b4:	5b                   	pop    %ebx
801020b5:	5e                   	pop    %esi
801020b6:	5f                   	pop    %edi
801020b7:	5d                   	pop    %ebp
801020b8:	c3                   	ret    
801020b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020c5:	8d 76 00             	lea    0x0(%esi),%esi
801020c8:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c9:	89 c1                	mov    %eax,%ecx
801020cb:	83 e1 c0             	and    $0xffffffc0,%ecx
801020ce:	80 f9 40             	cmp    $0x40,%cl
801020d1:	75 f5                	jne    801020c8 <ideintr+0x78>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020d3:	a8 21                	test   $0x21,%al
801020d5:	75 ab                	jne    80102082 <ideintr+0x32>
    insl(0x1f0, b->data, BSIZE/4);
801020d7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020da:	b9 80 00 00 00       	mov    $0x80,%ecx
801020df:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020e4:	fc                   	cld    
801020e5:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e7:	8b 33                	mov    (%ebx),%esi
801020e9:	eb 97                	jmp    80102082 <ideintr+0x32>
801020eb:	90                   	nop
801020ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	53                   	push   %ebx
801020f4:	83 ec 10             	sub    $0x10,%esp
801020f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801020fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801020fd:	50                   	push   %eax
801020fe:	e8 9d 20 00 00       	call   801041a0 <holdingsleep>
80102103:	83 c4 10             	add    $0x10,%esp
80102106:	85 c0                	test   %eax,%eax
80102108:	0f 84 ad 00 00 00    	je     801021bb <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010210e:	8b 03                	mov    (%ebx),%eax
80102110:	83 e0 06             	and    $0x6,%eax
80102113:	83 f8 02             	cmp    $0x2,%eax
80102116:	0f 84 b9 00 00 00    	je     801021d5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010211c:	8b 53 04             	mov    0x4(%ebx),%edx
8010211f:	85 d2                	test   %edx,%edx
80102121:	74 0d                	je     80102130 <iderw+0x40>
80102123:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102128:	85 c0                	test   %eax,%eax
8010212a:	0f 84 98 00 00 00    	je     801021c8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102130:	83 ec 0c             	sub    $0xc,%esp
80102133:	68 80 a5 10 80       	push   $0x8010a580
80102138:	e8 93 21 00 00       	call   801042d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010213d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102143:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102146:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010214d:	85 d2                	test   %edx,%edx
8010214f:	75 09                	jne    8010215a <iderw+0x6a>
80102151:	eb 58                	jmp    801021ab <iderw+0xbb>
80102153:	90                   	nop
80102154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102158:	89 c2                	mov    %eax,%edx
8010215a:	8b 42 58             	mov    0x58(%edx),%eax
8010215d:	85 c0                	test   %eax,%eax
8010215f:	75 f7                	jne    80102158 <iderw+0x68>
80102161:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102164:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102166:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
8010216c:	74 44                	je     801021b2 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010216e:	8b 03                	mov    (%ebx),%eax
80102170:	83 e0 06             	and    $0x6,%eax
80102173:	83 f8 02             	cmp    $0x2,%eax
80102176:	74 23                	je     8010219b <iderw+0xab>
80102178:	90                   	nop
80102179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102180:	83 ec 08             	sub    $0x8,%esp
80102183:	68 80 a5 10 80       	push   $0x8010a580
80102188:	53                   	push   %ebx
80102189:	e8 c2 1b 00 00       	call   80103d50 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010218e:	8b 03                	mov    (%ebx),%eax
80102190:	83 c4 10             	add    $0x10,%esp
80102193:	83 e0 06             	and    $0x6,%eax
80102196:	83 f8 02             	cmp    $0x2,%eax
80102199:	75 e5                	jne    80102180 <iderw+0x90>
  }


  release(&idelock);
8010219b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021a5:	c9                   	leave  
  release(&idelock);
801021a6:	e9 45 22 00 00       	jmp    801043f0 <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ab:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801021b0:	eb b2                	jmp    80102164 <iderw+0x74>
    idestart(b);
801021b2:	89 d8                	mov    %ebx,%eax
801021b4:	e8 47 fd ff ff       	call   80101f00 <idestart>
801021b9:	eb b3                	jmp    8010216e <iderw+0x7e>
    panic("iderw: buf not locked");
801021bb:	83 ec 0c             	sub    $0xc,%esp
801021be:	68 2a 71 10 80       	push   $0x8010712a
801021c3:	e8 a8 e1 ff ff       	call   80100370 <panic>
    panic("iderw: ide disk 1 not present");
801021c8:	83 ec 0c             	sub    $0xc,%esp
801021cb:	68 55 71 10 80       	push   $0x80107155
801021d0:	e8 9b e1 ff ff       	call   80100370 <panic>
    panic("iderw: nothing to do");
801021d5:	83 ec 0c             	sub    $0xc,%esp
801021d8:	68 40 71 10 80       	push   $0x80107140
801021dd:	e8 8e e1 ff ff       	call   80100370 <panic>
801021e2:	66 90                	xchg   %ax,%ax
801021e4:	66 90                	xchg   %ax,%ax
801021e6:	66 90                	xchg   %ax,%ax
801021e8:	66 90                	xchg   %ax,%ax
801021ea:	66 90                	xchg   %ax,%ax
801021ec:	66 90                	xchg   %ax,%ax
801021ee:	66 90                	xchg   %ax,%ax

801021f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021f0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021f1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801021f8:	00 c0 fe 
{
801021fb:	89 e5                	mov    %esp,%ebp
801021fd:	56                   	push   %esi
801021fe:	53                   	push   %ebx
  ioapic->reg = reg;
801021ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102206:	00 00 00 
  return ioapic->data;
80102209:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010220f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102212:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102218:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010221e:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102225:	c1 ee 10             	shr    $0x10,%esi
80102228:	89 f0                	mov    %esi,%eax
8010222a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010222d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102230:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102233:	39 d0                	cmp    %edx,%eax
80102235:	74 16                	je     8010224d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102237:	83 ec 0c             	sub    $0xc,%esp
8010223a:	68 74 71 10 80       	push   $0x80107174
8010223f:	e8 1c e4 ff ff       	call   80100660 <cprintf>
80102244:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010224a:	83 c4 10             	add    $0x10,%esp
8010224d:	83 c6 21             	add    $0x21,%esi
{
80102250:	ba 10 00 00 00       	mov    $0x10,%edx
80102255:	b8 20 00 00 00       	mov    $0x20,%eax
8010225a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102260:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102262:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102268:	89 c3                	mov    %eax,%ebx
8010226a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102270:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102273:	89 59 10             	mov    %ebx,0x10(%ecx)
80102276:	8d 5a 01             	lea    0x1(%edx),%ebx
80102279:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010227c:	39 f0                	cmp    %esi,%eax
  ioapic->reg = reg;
8010227e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102280:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102286:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010228d:	75 d1                	jne    80102260 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010228f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102292:	5b                   	pop    %ebx
80102293:	5e                   	pop    %esi
80102294:	5d                   	pop    %ebp
80102295:	c3                   	ret    
80102296:	8d 76 00             	lea    0x0(%esi),%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022a0:	55                   	push   %ebp
  ioapic->reg = reg;
801022a1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801022a7:	89 e5                	mov    %esp,%ebp
801022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ac:	8d 50 20             	lea    0x20(%eax),%edx
801022af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022b5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022be:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801022c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022c6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022cb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801022ce:	89 50 10             	mov    %edx,0x10(%eax)
}
801022d1:	5d                   	pop    %ebp
801022d2:	c3                   	ret    
801022d3:	66 90                	xchg   %ax,%ax
801022d5:	66 90                	xchg   %ax,%ax
801022d7:	66 90                	xchg   %ax,%ax
801022d9:	66 90                	xchg   %ax,%ax
801022db:	66 90                	xchg   %ax,%ax
801022dd:	66 90                	xchg   %ax,%ax
801022df:	90                   	nop

801022e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 04             	sub    $0x4,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022f0:	75 70                	jne    80102362 <kfree+0x82>
801022f2:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
801022f8:	72 68                	jb     80102362 <kfree+0x82>
801022fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102300:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102305:	77 5b                	ja     80102362 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102307:	83 ec 04             	sub    $0x4,%esp
8010230a:	68 00 10 00 00       	push   $0x1000
8010230f:	6a 01                	push   $0x1
80102311:	53                   	push   %ebx
80102312:	e8 29 21 00 00       	call   80104440 <memset>

  if(kmem.use_lock)
80102317:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010231d:	83 c4 10             	add    $0x10,%esp
80102320:	85 d2                	test   %edx,%edx
80102322:	75 2c                	jne    80102350 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102324:	a1 78 26 11 80       	mov    0x80112678,%eax
80102329:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010232b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102330:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102336:	85 c0                	test   %eax,%eax
80102338:	75 06                	jne    80102340 <kfree+0x60>
    release(&kmem.lock);
}
8010233a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010233d:	c9                   	leave  
8010233e:	c3                   	ret    
8010233f:	90                   	nop
    release(&kmem.lock);
80102340:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102347:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010234a:	c9                   	leave  
    release(&kmem.lock);
8010234b:	e9 a0 20 00 00       	jmp    801043f0 <release>
    acquire(&kmem.lock);
80102350:	83 ec 0c             	sub    $0xc,%esp
80102353:	68 40 26 11 80       	push   $0x80112640
80102358:	e8 73 1f 00 00       	call   801042d0 <acquire>
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	eb c2                	jmp    80102324 <kfree+0x44>
    panic("kfree");
80102362:	83 ec 0c             	sub    $0xc,%esp
80102365:	68 a6 71 10 80       	push   $0x801071a6
8010236a:	e8 01 e0 ff ff       	call   80100370 <panic>
8010236f:	90                   	nop

80102370 <freerange>:
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	56                   	push   %esi
80102374:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102375:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102378:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010237b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102381:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102387:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010238d:	39 de                	cmp    %ebx,%esi
8010238f:	72 23                	jb     801023b4 <freerange+0x44>
80102391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102398:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010239e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023a7:	50                   	push   %eax
801023a8:	e8 33 ff ff ff       	call   801022e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ad:	83 c4 10             	add    $0x10,%esp
801023b0:	39 f3                	cmp    %esi,%ebx
801023b2:	76 e4                	jbe    80102398 <freerange+0x28>
}
801023b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023b7:	5b                   	pop    %ebx
801023b8:	5e                   	pop    %esi
801023b9:	5d                   	pop    %ebp
801023ba:	c3                   	ret    
801023bb:	90                   	nop
801023bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023c0 <kinit1>:
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
801023c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023c8:	83 ec 08             	sub    $0x8,%esp
801023cb:	68 ac 71 10 80       	push   $0x801071ac
801023d0:	68 40 26 11 80       	push   $0x80112640
801023d5:	e8 f6 1d 00 00       	call   801041d0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801023da:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023dd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801023e0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801023e7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801023ea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023fc:	39 de                	cmp    %ebx,%esi
801023fe:	72 1c                	jb     8010241c <kinit1+0x5c>
    kfree(p);
80102400:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102406:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102409:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010240f:	50                   	push   %eax
80102410:	e8 cb fe ff ff       	call   801022e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102415:	83 c4 10             	add    $0x10,%esp
80102418:	39 de                	cmp    %ebx,%esi
8010241a:	73 e4                	jae    80102400 <kinit1+0x40>
}
8010241c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010241f:	5b                   	pop    %ebx
80102420:	5e                   	pop    %esi
80102421:	5d                   	pop    %ebp
80102422:	c3                   	ret    
80102423:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102430 <kinit2>:
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	56                   	push   %esi
80102434:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102435:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102438:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010243b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102441:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102447:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010244d:	39 de                	cmp    %ebx,%esi
8010244f:	72 23                	jb     80102474 <kinit2+0x44>
80102451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102458:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010245e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102461:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102467:	50                   	push   %eax
80102468:	e8 73 fe ff ff       	call   801022e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010246d:	83 c4 10             	add    $0x10,%esp
80102470:	39 de                	cmp    %ebx,%esi
80102472:	73 e4                	jae    80102458 <kinit2+0x28>
  kmem.use_lock = 1;
80102474:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010247b:	00 00 00 
}
8010247e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102481:	5b                   	pop    %ebx
80102482:	5e                   	pop    %esi
80102483:	5d                   	pop    %ebp
80102484:	c3                   	ret    
80102485:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102490 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102497:	a1 74 26 11 80       	mov    0x80112674,%eax
8010249c:	85 c0                	test   %eax,%eax
8010249e:	75 30                	jne    801024d0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024a0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024a6:	85 db                	test   %ebx,%ebx
801024a8:	74 1c                	je     801024c6 <kalloc+0x36>
    kmem.freelist = r->next;
801024aa:	8b 13                	mov    (%ebx),%edx
801024ac:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024b2:	85 c0                	test   %eax,%eax
801024b4:	74 10                	je     801024c6 <kalloc+0x36>
    release(&kmem.lock);
801024b6:	83 ec 0c             	sub    $0xc,%esp
801024b9:	68 40 26 11 80       	push   $0x80112640
801024be:	e8 2d 1f 00 00       	call   801043f0 <release>
801024c3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801024c6:	89 d8                	mov    %ebx,%eax
801024c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024cb:	c9                   	leave  
801024cc:	c3                   	ret    
801024cd:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
801024d0:	83 ec 0c             	sub    $0xc,%esp
801024d3:	68 40 26 11 80       	push   $0x80112640
801024d8:	e8 f3 1d 00 00       	call   801042d0 <acquire>
  r = kmem.freelist;
801024dd:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024e3:	83 c4 10             	add    $0x10,%esp
801024e6:	a1 74 26 11 80       	mov    0x80112674,%eax
801024eb:	85 db                	test   %ebx,%ebx
801024ed:	75 bb                	jne    801024aa <kalloc+0x1a>
801024ef:	eb c1                	jmp    801024b2 <kalloc+0x22>
801024f1:	66 90                	xchg   %ax,%ax
801024f3:	66 90                	xchg   %ax,%ax
801024f5:	66 90                	xchg   %ax,%ax
801024f7:	66 90                	xchg   %ax,%ax
801024f9:	66 90                	xchg   %ax,%ax
801024fb:	66 90                	xchg   %ax,%ax
801024fd:	66 90                	xchg   %ax,%ax
801024ff:	90                   	nop

80102500 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102500:	ba 64 00 00 00       	mov    $0x64,%edx
80102505:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102506:	a8 01                	test   $0x1,%al
80102508:	0f 84 c2 00 00 00    	je     801025d0 <kbdgetc+0xd0>
8010250e:	ba 60 00 00 00       	mov    $0x60,%edx
80102513:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102514:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102517:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
8010251d:	0f 84 9d 00 00 00    	je     801025c0 <kbdgetc+0xc0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102523:	84 c0                	test   %al,%al
80102525:	78 59                	js     80102580 <kbdgetc+0x80>
{
80102527:	55                   	push   %ebp
80102528:	89 e5                	mov    %esp,%ebp
8010252a:	53                   	push   %ebx
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010252b:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
80102531:	f6 c3 40             	test   $0x40,%bl
80102534:	74 09                	je     8010253f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102536:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102539:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010253c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010253f:	0f b6 8a e0 72 10 80 	movzbl -0x7fef8d20(%edx),%ecx
  shift ^= togglecode[data];
80102546:	0f b6 82 e0 71 10 80 	movzbl -0x7fef8e20(%edx),%eax
  shift |= shiftcode[data];
8010254d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010254f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102551:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102553:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102559:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010255c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010255f:	8b 04 85 c0 71 10 80 	mov    -0x7fef8e40(,%eax,4),%eax
80102566:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010256a:	74 0b                	je     80102577 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010256c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010256f:	83 fa 19             	cmp    $0x19,%edx
80102572:	77 3c                	ja     801025b0 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102574:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102577:	5b                   	pop    %ebx
80102578:	5d                   	pop    %ebp
80102579:	c3                   	ret    
8010257a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    data = (shift & E0ESC ? data : data & 0x7F);
80102580:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
80102586:	83 e0 7f             	and    $0x7f,%eax
80102589:	f6 c1 40             	test   $0x40,%cl
8010258c:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
8010258f:	0f b6 82 e0 72 10 80 	movzbl -0x7fef8d20(%edx),%eax
80102596:	83 c8 40             	or     $0x40,%eax
80102599:	0f b6 c0             	movzbl %al,%eax
8010259c:	f7 d0                	not    %eax
8010259e:	21 c8                	and    %ecx,%eax
801025a0:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
801025a5:	31 c0                	xor    %eax,%eax
801025a7:	c3                   	ret    
801025a8:	90                   	nop
801025a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801025b0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025b3:	8d 50 20             	lea    0x20(%eax),%edx
}
801025b6:	5b                   	pop    %ebx
      c += 'a' - 'A';
801025b7:	83 f9 19             	cmp    $0x19,%ecx
801025ba:	0f 46 c2             	cmovbe %edx,%eax
}
801025bd:	5d                   	pop    %ebp
801025be:	c3                   	ret    
801025bf:	90                   	nop
    shift |= E0ESC;
801025c0:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025c7:	31 c0                	xor    %eax,%eax
801025c9:	c3                   	ret    
801025ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801025d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025d5:	c3                   	ret    
801025d6:	8d 76 00             	lea    0x0(%esi),%esi
801025d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025e0 <kbdintr>:

void
kbdintr(void)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801025e6:	68 00 25 10 80       	push   $0x80102500
801025eb:	e8 f0 e1 ff ff       	call   801007e0 <consoleintr>
}
801025f0:	83 c4 10             	add    $0x10,%esp
801025f3:	c9                   	leave  
801025f4:	c3                   	ret    
801025f5:	66 90                	xchg   %ax,%ax
801025f7:	66 90                	xchg   %ax,%ax
801025f9:	66 90                	xchg   %ax,%ax
801025fb:	66 90                	xchg   %ax,%ax
801025fd:	66 90                	xchg   %ax,%ax
801025ff:	90                   	nop

80102600 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102600:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102605:	55                   	push   %ebp
80102606:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102608:	85 c0                	test   %eax,%eax
8010260a:	0f 84 c8 00 00 00    	je     801026d8 <lapicinit+0xd8>
  lapic[index] = value;
80102610:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102617:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010261a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010261d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102624:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102627:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010262a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102631:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102634:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102637:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010263e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102641:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102644:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010264b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010264e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102651:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102658:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010265b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010265e:	8b 50 30             	mov    0x30(%eax),%edx
80102661:	c1 ea 10             	shr    $0x10,%edx
80102664:	80 fa 03             	cmp    $0x3,%dl
80102667:	77 77                	ja     801026e0 <lapicinit+0xe0>
  lapic[index] = value;
80102669:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102670:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102673:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102676:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010267d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102680:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102683:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010268a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010268d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102690:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102697:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010269a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010269d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026aa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026b1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026b4:	8b 50 20             	mov    0x20(%eax),%edx
801026b7:	89 f6                	mov    %esi,%esi
801026b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026c6:	80 e6 10             	and    $0x10,%dh
801026c9:	75 f5                	jne    801026c0 <lapicinit+0xc0>
  lapic[index] = value;
801026cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801026d8:	5d                   	pop    %ebp
801026d9:	c3                   	ret    
801026da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
801026e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ea:	8b 50 20             	mov    0x20(%eax),%edx
801026ed:	e9 77 ff ff ff       	jmp    80102669 <lapicinit+0x69>
801026f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102700 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102700:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102705:	55                   	push   %ebp
80102706:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102708:	85 c0                	test   %eax,%eax
8010270a:	74 0c                	je     80102718 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010270c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010270f:	5d                   	pop    %ebp
  return lapic[ID] >> 24;
80102710:	c1 e8 18             	shr    $0x18,%eax
}
80102713:	c3                   	ret    
80102714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102718:	31 c0                	xor    %eax,%eax
8010271a:	5d                   	pop    %ebp
8010271b:	c3                   	ret    
8010271c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102720 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102720:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102725:	55                   	push   %ebp
80102726:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102728:	85 c0                	test   %eax,%eax
8010272a:	74 0d                	je     80102739 <lapiceoi+0x19>
  lapic[index] = value;
8010272c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102733:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102736:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102739:	5d                   	pop    %ebp
8010273a:	c3                   	ret    
8010273b:	90                   	nop
8010273c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102740 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
}
80102743:	5d                   	pop    %ebp
80102744:	c3                   	ret    
80102745:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102750:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102751:	ba 70 00 00 00       	mov    $0x70,%edx
80102756:	b8 0f 00 00 00       	mov    $0xf,%eax
8010275b:	89 e5                	mov    %esp,%ebp
8010275d:	53                   	push   %ebx
8010275e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102761:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102764:	ee                   	out    %al,(%dx)
80102765:	ba 71 00 00 00       	mov    $0x71,%edx
8010276a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010276f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102770:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102772:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102775:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010277b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010277d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102780:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102783:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102785:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102788:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010278e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102793:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102799:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010279c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027a3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027a9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027b0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027b3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027b6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027bc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027bf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027c8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027d1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027d7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801027da:	5b                   	pop    %ebx
801027db:	5d                   	pop    %ebp
801027dc:	c3                   	ret    
801027dd:	8d 76 00             	lea    0x0(%esi),%esi

801027e0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801027e0:	55                   	push   %ebp
801027e1:	ba 70 00 00 00       	mov    $0x70,%edx
801027e6:	b8 0b 00 00 00       	mov    $0xb,%eax
801027eb:	89 e5                	mov    %esp,%ebp
801027ed:	57                   	push   %edi
801027ee:	56                   	push   %esi
801027ef:	53                   	push   %ebx
801027f0:	83 ec 5c             	sub    $0x5c,%esp
801027f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027f4:	ba 71 00 00 00       	mov    $0x71,%edx
801027f9:	ec                   	in     (%dx),%al
801027fa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027fd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102802:	88 45 a7             	mov    %al,-0x59(%ebp)
80102805:	8d 76 00             	lea    0x0(%esi),%esi
80102808:	31 c0                	xor    %eax,%eax
8010280a:	89 da                	mov    %ebx,%edx
8010280c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010280d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102812:	89 ca                	mov    %ecx,%edx
80102814:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
80102815:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102818:	89 da                	mov    %ebx,%edx
8010281a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010281d:	b8 02 00 00 00       	mov    $0x2,%eax
80102822:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102823:	89 ca                	mov    %ecx,%edx
80102825:	ec                   	in     (%dx),%al
80102826:	0f b6 f0             	movzbl %al,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102829:	89 da                	mov    %ebx,%edx
8010282b:	b8 04 00 00 00       	mov    $0x4,%eax
80102830:	89 75 b0             	mov    %esi,-0x50(%ebp)
80102833:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102834:	89 ca                	mov    %ecx,%edx
80102836:	ec                   	in     (%dx),%al
80102837:	0f b6 f8             	movzbl %al,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010283a:	89 da                	mov    %ebx,%edx
8010283c:	b8 07 00 00 00       	mov    $0x7,%eax
80102841:	89 7d ac             	mov    %edi,-0x54(%ebp)
80102844:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102845:	89 ca                	mov    %ecx,%edx
80102847:	ec                   	in     (%dx),%al
80102848:	0f b6 d0             	movzbl %al,%edx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010284b:	b8 08 00 00 00       	mov    $0x8,%eax
80102850:	89 55 a8             	mov    %edx,-0x58(%ebp)
80102853:	89 da                	mov    %ebx,%edx
80102855:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102856:	89 ca                	mov    %ecx,%edx
80102858:	ec                   	in     (%dx),%al
80102859:	0f b6 f8             	movzbl %al,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010285c:	89 da                	mov    %ebx,%edx
8010285e:	b8 09 00 00 00       	mov    $0x9,%eax
80102863:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102864:	89 ca                	mov    %ecx,%edx
80102866:	ec                   	in     (%dx),%al
80102867:	0f b6 f0             	movzbl %al,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010286a:	89 da                	mov    %ebx,%edx
8010286c:	b8 0a 00 00 00       	mov    $0xa,%eax
80102871:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102872:	89 ca                	mov    %ecx,%edx
80102874:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102875:	84 c0                	test   %al,%al
80102877:	78 8f                	js     80102808 <cmostime+0x28>
80102879:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010287c:	8b 55 a8             	mov    -0x58(%ebp),%edx
8010287f:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102882:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102885:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102888:	8b 45 b0             	mov    -0x50(%ebp),%eax
8010288b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288e:	89 da                	mov    %ebx,%edx
80102890:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102893:	8b 45 ac             	mov    -0x54(%ebp),%eax
80102896:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102899:	31 c0                	xor    %eax,%eax
8010289b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289c:	89 ca                	mov    %ecx,%edx
8010289e:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
8010289f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a2:	89 da                	mov    %ebx,%edx
801028a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028a7:	b8 02 00 00 00       	mov    $0x2,%eax
801028ac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ad:	89 ca                	mov    %ecx,%edx
801028af:	ec                   	in     (%dx),%al
801028b0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b3:	89 da                	mov    %ebx,%edx
801028b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028b8:	b8 04 00 00 00       	mov    $0x4,%eax
801028bd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028be:	89 ca                	mov    %ecx,%edx
801028c0:	ec                   	in     (%dx),%al
801028c1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c4:	89 da                	mov    %ebx,%edx
801028c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028c9:	b8 07 00 00 00       	mov    $0x7,%eax
801028ce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028cf:	89 ca                	mov    %ecx,%edx
801028d1:	ec                   	in     (%dx),%al
801028d2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d5:	89 da                	mov    %ebx,%edx
801028d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801028da:	b8 08 00 00 00       	mov    $0x8,%eax
801028df:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028e0:	89 ca                	mov    %ecx,%edx
801028e2:	ec                   	in     (%dx),%al
801028e3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e6:	89 da                	mov    %ebx,%edx
801028e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801028eb:	b8 09 00 00 00       	mov    $0x9,%eax
801028f0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f1:	89 ca                	mov    %ecx,%edx
801028f3:	ec                   	in     (%dx),%al
801028f4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028f7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801028fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028fd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102900:	6a 18                	push   $0x18
80102902:	50                   	push   %eax
80102903:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102906:	50                   	push   %eax
80102907:	e8 84 1b 00 00       	call   80104490 <memcmp>
8010290c:	83 c4 10             	add    $0x10,%esp
8010290f:	85 c0                	test   %eax,%eax
80102911:	0f 85 f1 fe ff ff    	jne    80102808 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102917:	80 7d a7 00          	cmpb   $0x0,-0x59(%ebp)
8010291b:	75 78                	jne    80102995 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010291d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102920:	89 c2                	mov    %eax,%edx
80102922:	83 e0 0f             	and    $0xf,%eax
80102925:	c1 ea 04             	shr    $0x4,%edx
80102928:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010292b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010292e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102931:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102934:	89 c2                	mov    %eax,%edx
80102936:	83 e0 0f             	and    $0xf,%eax
80102939:	c1 ea 04             	shr    $0x4,%edx
8010293c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010293f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102942:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102945:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102948:	89 c2                	mov    %eax,%edx
8010294a:	83 e0 0f             	and    $0xf,%eax
8010294d:	c1 ea 04             	shr    $0x4,%edx
80102950:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102953:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102956:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102959:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010295c:	89 c2                	mov    %eax,%edx
8010295e:	83 e0 0f             	and    $0xf,%eax
80102961:	c1 ea 04             	shr    $0x4,%edx
80102964:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102967:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010296a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010296d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102970:	89 c2                	mov    %eax,%edx
80102972:	83 e0 0f             	and    $0xf,%eax
80102975:	c1 ea 04             	shr    $0x4,%edx
80102978:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010297b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010297e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102981:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102984:	89 c2                	mov    %eax,%edx
80102986:	83 e0 0f             	and    $0xf,%eax
80102989:	c1 ea 04             	shr    $0x4,%edx
8010298c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010298f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102992:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102995:	8b 75 08             	mov    0x8(%ebp),%esi
80102998:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010299b:	89 06                	mov    %eax,(%esi)
8010299d:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029a0:	89 46 04             	mov    %eax,0x4(%esi)
801029a3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029a6:	89 46 08             	mov    %eax,0x8(%esi)
801029a9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029ac:	89 46 0c             	mov    %eax,0xc(%esi)
801029af:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029b2:	89 46 10             	mov    %eax,0x10(%esi)
801029b5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029bb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801029c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029c5:	5b                   	pop    %ebx
801029c6:	5e                   	pop    %esi
801029c7:	5f                   	pop    %edi
801029c8:	5d                   	pop    %ebp
801029c9:	c3                   	ret    
801029ca:	66 90                	xchg   %ax,%ax
801029cc:	66 90                	xchg   %ax,%ax
801029ce:	66 90                	xchg   %ax,%ax

801029d0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029d0:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
801029d6:	85 c9                	test   %ecx,%ecx
801029d8:	0f 8e 85 00 00 00    	jle    80102a63 <install_trans+0x93>
{
801029de:	55                   	push   %ebp
801029df:	89 e5                	mov    %esp,%ebp
801029e1:	57                   	push   %edi
801029e2:	56                   	push   %esi
801029e3:	53                   	push   %ebx
801029e4:	31 db                	xor    %ebx,%ebx
801029e6:	83 ec 0c             	sub    $0xc,%esp
801029e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029f0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801029f5:	83 ec 08             	sub    $0x8,%esp
801029f8:	01 d8                	add    %ebx,%eax
801029fa:	83 c0 01             	add    $0x1,%eax
801029fd:	50                   	push   %eax
801029fe:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102a04:	e8 c7 d6 ff ff       	call   801000d0 <bread>
80102a09:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a0b:	58                   	pop    %eax
80102a0c:	5a                   	pop    %edx
80102a0d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102a14:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a1a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a1d:	e8 ae d6 ff ff       	call   801000d0 <bread>
80102a22:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a24:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a27:	83 c4 0c             	add    $0xc,%esp
80102a2a:	68 00 02 00 00       	push   $0x200
80102a2f:	50                   	push   %eax
80102a30:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a33:	50                   	push   %eax
80102a34:	e8 b7 1a 00 00       	call   801044f0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a39:	89 34 24             	mov    %esi,(%esp)
80102a3c:	e8 5f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a41:	89 3c 24             	mov    %edi,(%esp)
80102a44:	e8 97 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a49:	89 34 24             	mov    %esi,(%esp)
80102a4c:	e8 8f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a51:	83 c4 10             	add    $0x10,%esp
80102a54:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a5a:	7f 94                	jg     801029f0 <install_trans+0x20>
  }
}
80102a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a5f:	5b                   	pop    %ebx
80102a60:	5e                   	pop    %esi
80102a61:	5f                   	pop    %edi
80102a62:	5d                   	pop    %ebp
80102a63:	f3 c3                	repz ret 
80102a65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	53                   	push   %ebx
80102a74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a77:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102a7d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102a83:	e8 48 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a88:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102a8e:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a91:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a93:	85 c9                	test   %ecx,%ecx
  hb->n = log.lh.n;
80102a95:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102a98:	7e 1f                	jle    80102ab9 <write_head+0x49>
80102a9a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102aa1:	31 d2                	xor    %edx,%edx
80102aa3:	90                   	nop
80102aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102aa8:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102aae:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102ab2:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102ab5:	39 c2                	cmp    %eax,%edx
80102ab7:	75 ef                	jne    80102aa8 <write_head+0x38>
  }
  bwrite(buf);
80102ab9:	83 ec 0c             	sub    $0xc,%esp
80102abc:	53                   	push   %ebx
80102abd:	e8 de d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102ac2:	89 1c 24             	mov    %ebx,(%esp)
80102ac5:	e8 16 d7 ff ff       	call   801001e0 <brelse>
}
80102aca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102acd:	c9                   	leave  
80102ace:	c3                   	ret    
80102acf:	90                   	nop

80102ad0 <initlog>:
{
80102ad0:	55                   	push   %ebp
80102ad1:	89 e5                	mov    %esp,%ebp
80102ad3:	53                   	push   %ebx
80102ad4:	83 ec 2c             	sub    $0x2c,%esp
80102ad7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102ada:	68 e0 73 10 80       	push   $0x801073e0
80102adf:	68 80 26 11 80       	push   $0x80112680
80102ae4:	e8 e7 16 00 00       	call   801041d0 <initlock>
  readsb(dev, &sb);
80102ae9:	58                   	pop    %eax
80102aea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102aed:	5a                   	pop    %edx
80102aee:	50                   	push   %eax
80102aef:	53                   	push   %ebx
80102af0:	e8 bb e8 ff ff       	call   801013b0 <readsb>
  log.size = sb.nlog;
80102af5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102afb:	59                   	pop    %ecx
  log.dev = dev;
80102afc:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102b02:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102b08:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102b0d:	5a                   	pop    %edx
80102b0e:	50                   	push   %eax
80102b0f:	53                   	push   %ebx
80102b10:	e8 bb d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b15:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102b18:	83 c4 10             	add    $0x10,%esp
80102b1b:	85 c9                	test   %ecx,%ecx
  log.lh.n = lh->n;
80102b1d:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102b23:	7e 1c                	jle    80102b41 <initlog+0x71>
80102b25:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102b2c:	31 d2                	xor    %edx,%edx
80102b2e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102b30:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b34:	83 c2 04             	add    $0x4,%edx
80102b37:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b3d:	39 da                	cmp    %ebx,%edx
80102b3f:	75 ef                	jne    80102b30 <initlog+0x60>
  brelse(buf);
80102b41:	83 ec 0c             	sub    $0xc,%esp
80102b44:	50                   	push   %eax
80102b45:	e8 96 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b4a:	e8 81 fe ff ff       	call   801029d0 <install_trans>
  log.lh.n = 0;
80102b4f:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b56:	00 00 00 
  write_head(); // clear the log
80102b59:	e8 12 ff ff ff       	call   80102a70 <write_head>
}
80102b5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b61:	c9                   	leave  
80102b62:	c3                   	ret    
80102b63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
80102b73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102b76:	68 80 26 11 80       	push   $0x80112680
80102b7b:	e8 50 17 00 00       	call   801042d0 <acquire>
80102b80:	83 c4 10             	add    $0x10,%esp
80102b83:	eb 18                	jmp    80102b9d <begin_op+0x2d>
80102b85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b88:	83 ec 08             	sub    $0x8,%esp
80102b8b:	68 80 26 11 80       	push   $0x80112680
80102b90:	68 80 26 11 80       	push   $0x80112680
80102b95:	e8 b6 11 00 00       	call   80103d50 <sleep>
80102b9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102b9d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102ba2:	85 c0                	test   %eax,%eax
80102ba4:	75 e2                	jne    80102b88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102ba6:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102bab:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102bb1:	83 c0 01             	add    $0x1,%eax
80102bb4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102bb7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bba:	83 fa 1e             	cmp    $0x1e,%edx
80102bbd:	7f c9                	jg     80102b88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bbf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102bc2:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102bc7:	68 80 26 11 80       	push   $0x80112680
80102bcc:	e8 1f 18 00 00       	call   801043f0 <release>
      break;
    }
  }
}
80102bd1:	83 c4 10             	add    $0x10,%esp
80102bd4:	c9                   	leave  
80102bd5:	c3                   	ret    
80102bd6:	8d 76 00             	lea    0x0(%esi),%esi
80102bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102be0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102be0:	55                   	push   %ebp
80102be1:	89 e5                	mov    %esp,%ebp
80102be3:	57                   	push   %edi
80102be4:	56                   	push   %esi
80102be5:	53                   	push   %ebx
80102be6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102be9:	68 80 26 11 80       	push   $0x80112680
80102bee:	e8 dd 16 00 00       	call   801042d0 <acquire>
  log.outstanding -= 1;
80102bf3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102bf8:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102bfe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c01:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c04:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c06:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102c0c:	0f 85 22 01 00 00    	jne    80102d34 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102c12:	85 db                	test   %ebx,%ebx
80102c14:	0f 85 f6 00 00 00    	jne    80102d10 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c1a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c1d:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102c24:	00 00 00 
  release(&log.lock);
80102c27:	68 80 26 11 80       	push   $0x80112680
80102c2c:	e8 bf 17 00 00       	call   801043f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c31:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102c37:	83 c4 10             	add    $0x10,%esp
80102c3a:	85 c9                	test   %ecx,%ecx
80102c3c:	0f 8e 8b 00 00 00    	jle    80102ccd <end_op+0xed>
80102c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c48:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c4d:	83 ec 08             	sub    $0x8,%esp
80102c50:	01 d8                	add    %ebx,%eax
80102c52:	83 c0 01             	add    $0x1,%eax
80102c55:	50                   	push   %eax
80102c56:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c5c:	e8 6f d4 ff ff       	call   801000d0 <bread>
80102c61:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c63:	58                   	pop    %eax
80102c64:	5a                   	pop    %edx
80102c65:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102c6c:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c72:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c75:	e8 56 d4 ff ff       	call   801000d0 <bread>
80102c7a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c7c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c7f:	83 c4 0c             	add    $0xc,%esp
80102c82:	68 00 02 00 00       	push   $0x200
80102c87:	50                   	push   %eax
80102c88:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c8b:	50                   	push   %eax
80102c8c:	e8 5f 18 00 00       	call   801044f0 <memmove>
    bwrite(to);  // write the log
80102c91:	89 34 24             	mov    %esi,(%esp)
80102c94:	e8 07 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c99:	89 3c 24             	mov    %edi,(%esp)
80102c9c:	e8 3f d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ca1:	89 34 24             	mov    %esi,(%esp)
80102ca4:	e8 37 d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ca9:	83 c4 10             	add    $0x10,%esp
80102cac:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102cb2:	7c 94                	jl     80102c48 <end_op+0x68>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cb4:	e8 b7 fd ff ff       	call   80102a70 <write_head>
    install_trans(); // Now install writes to home locations
80102cb9:	e8 12 fd ff ff       	call   801029d0 <install_trans>
    log.lh.n = 0;
80102cbe:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102cc5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cc8:	e8 a3 fd ff ff       	call   80102a70 <write_head>
    acquire(&log.lock);
80102ccd:	83 ec 0c             	sub    $0xc,%esp
80102cd0:	68 80 26 11 80       	push   $0x80112680
80102cd5:	e8 f6 15 00 00       	call   801042d0 <acquire>
    wakeup(&log);
80102cda:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102ce1:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102ce8:	00 00 00 
    wakeup(&log);
80102ceb:	e8 20 12 00 00       	call   80103f10 <wakeup>
    release(&log.lock);
80102cf0:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cf7:	e8 f4 16 00 00       	call   801043f0 <release>
80102cfc:	83 c4 10             	add    $0x10,%esp
}
80102cff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d02:	5b                   	pop    %ebx
80102d03:	5e                   	pop    %esi
80102d04:	5f                   	pop    %edi
80102d05:	5d                   	pop    %ebp
80102d06:	c3                   	ret    
80102d07:	89 f6                	mov    %esi,%esi
80102d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    wakeup(&log);
80102d10:	83 ec 0c             	sub    $0xc,%esp
80102d13:	68 80 26 11 80       	push   $0x80112680
80102d18:	e8 f3 11 00 00       	call   80103f10 <wakeup>
  release(&log.lock);
80102d1d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d24:	e8 c7 16 00 00       	call   801043f0 <release>
80102d29:	83 c4 10             	add    $0x10,%esp
}
80102d2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d2f:	5b                   	pop    %ebx
80102d30:	5e                   	pop    %esi
80102d31:	5f                   	pop    %edi
80102d32:	5d                   	pop    %ebp
80102d33:	c3                   	ret    
    panic("log.committing");
80102d34:	83 ec 0c             	sub    $0xc,%esp
80102d37:	68 e4 73 10 80       	push   $0x801073e4
80102d3c:	e8 2f d6 ff ff       	call   80100370 <panic>
80102d41:	eb 0d                	jmp    80102d50 <log_write>
80102d43:	90                   	nop
80102d44:	90                   	nop
80102d45:	90                   	nop
80102d46:	90                   	nop
80102d47:	90                   	nop
80102d48:	90                   	nop
80102d49:	90                   	nop
80102d4a:	90                   	nop
80102d4b:	90                   	nop
80102d4c:	90                   	nop
80102d4d:	90                   	nop
80102d4e:	90                   	nop
80102d4f:	90                   	nop

80102d50 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d50:	55                   	push   %ebp
80102d51:	89 e5                	mov    %esp,%ebp
80102d53:	53                   	push   %ebx
80102d54:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d57:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102d5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d60:	83 fa 1d             	cmp    $0x1d,%edx
80102d63:	0f 8f 97 00 00 00    	jg     80102e00 <log_write+0xb0>
80102d69:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102d6e:	83 e8 01             	sub    $0x1,%eax
80102d71:	39 c2                	cmp    %eax,%edx
80102d73:	0f 8d 87 00 00 00    	jge    80102e00 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d79:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d7e:	85 c0                	test   %eax,%eax
80102d80:	0f 8e 87 00 00 00    	jle    80102e0d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d86:	83 ec 0c             	sub    $0xc,%esp
80102d89:	68 80 26 11 80       	push   $0x80112680
80102d8e:	e8 3d 15 00 00       	call   801042d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d93:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102d99:	83 c4 10             	add    $0x10,%esp
80102d9c:	83 f9 00             	cmp    $0x0,%ecx
80102d9f:	7e 50                	jle    80102df1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102da1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102da4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102da6:	3b 15 cc 26 11 80    	cmp    0x801126cc,%edx
80102dac:	75 0b                	jne    80102db9 <log_write+0x69>
80102dae:	eb 38                	jmp    80102de8 <log_write+0x98>
80102db0:	39 14 85 cc 26 11 80 	cmp    %edx,-0x7feed934(,%eax,4)
80102db7:	74 2f                	je     80102de8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102db9:	83 c0 01             	add    $0x1,%eax
80102dbc:	39 c8                	cmp    %ecx,%eax
80102dbe:	75 f0                	jne    80102db0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102dc0:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102dc7:	83 c0 01             	add    $0x1,%eax
80102dca:	a3 c8 26 11 80       	mov    %eax,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102dcf:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102dd2:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102dd9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ddc:	c9                   	leave  
  release(&log.lock);
80102ddd:	e9 0e 16 00 00       	jmp    801043f0 <release>
80102de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102de8:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
80102def:	eb de                	jmp    80102dcf <log_write+0x7f>
80102df1:	8b 43 08             	mov    0x8(%ebx),%eax
80102df4:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102df9:	75 d4                	jne    80102dcf <log_write+0x7f>
80102dfb:	31 c0                	xor    %eax,%eax
80102dfd:	eb c8                	jmp    80102dc7 <log_write+0x77>
80102dff:	90                   	nop
    panic("too big a transaction");
80102e00:	83 ec 0c             	sub    $0xc,%esp
80102e03:	68 f3 73 10 80       	push   $0x801073f3
80102e08:	e8 63 d5 ff ff       	call   80100370 <panic>
    panic("log_write outside of trans");
80102e0d:	83 ec 0c             	sub    $0xc,%esp
80102e10:	68 09 74 10 80       	push   $0x80107409
80102e15:	e8 56 d5 ff ff       	call   80100370 <panic>
80102e1a:	66 90                	xchg   %ax,%ax
80102e1c:	66 90                	xchg   %ax,%ax
80102e1e:	66 90                	xchg   %ax,%ax

80102e20 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	53                   	push   %ebx
80102e24:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e27:	e8 44 09 00 00       	call   80103770 <cpuid>
80102e2c:	89 c3                	mov    %eax,%ebx
80102e2e:	e8 3d 09 00 00       	call   80103770 <cpuid>
80102e33:	83 ec 04             	sub    $0x4,%esp
80102e36:	53                   	push   %ebx
80102e37:	50                   	push   %eax
80102e38:	68 24 74 10 80       	push   $0x80107424
80102e3d:	e8 1e d8 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e42:	e8 29 29 00 00       	call   80105770 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e47:	e8 a4 08 00 00       	call   801036f0 <mycpu>
80102e4c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e4e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e53:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e5a:	e8 f1 0b 00 00       	call   80103a50 <scheduler>
80102e5f:	90                   	nop

80102e60 <mpenter>:
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e66:	e8 25 3a 00 00       	call   80106890 <switchkvm>
  seginit();
80102e6b:	e8 20 39 00 00       	call   80106790 <seginit>
  lapicinit();
80102e70:	e8 8b f7 ff ff       	call   80102600 <lapicinit>
  mpmain();
80102e75:	e8 a6 ff ff ff       	call   80102e20 <mpmain>
80102e7a:	66 90                	xchg   %ax,%ax
80102e7c:	66 90                	xchg   %ax,%ax
80102e7e:	66 90                	xchg   %ax,%ax

80102e80 <main>:
{
80102e80:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102e84:	83 e4 f0             	and    $0xfffffff0,%esp
80102e87:	ff 71 fc             	pushl  -0x4(%ecx)
80102e8a:	55                   	push   %ebp
80102e8b:	89 e5                	mov    %esp,%ebp
80102e8d:	53                   	push   %ebx
80102e8e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e8f:	bb 80 27 11 80       	mov    $0x80112780,%ebx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e94:	83 ec 08             	sub    $0x8,%esp
80102e97:	68 00 00 40 80       	push   $0x80400000
80102e9c:	68 a8 54 11 80       	push   $0x801154a8
80102ea1:	e8 1a f5 ff ff       	call   801023c0 <kinit1>
  kvmalloc();      // kernel page table
80102ea6:	e8 75 3e 00 00       	call   80106d20 <kvmalloc>
  mpinit();        // detect other processors
80102eab:	e8 60 01 00 00       	call   80103010 <mpinit>
  lapicinit();     // interrupt controller
80102eb0:	e8 4b f7 ff ff       	call   80102600 <lapicinit>
  seginit();       // segment descriptors
80102eb5:	e8 d6 38 00 00       	call   80106790 <seginit>
  picinit();       // disable pic
80102eba:	e8 21 03 00 00       	call   801031e0 <picinit>
  ioapicinit();    // another interrupt controller
80102ebf:	e8 2c f3 ff ff       	call   801021f0 <ioapicinit>
  consoleinit();   // console hardware
80102ec4:	e8 c7 da ff ff       	call   80100990 <consoleinit>
  uartinit();      // serial port
80102ec9:	e8 92 2b 00 00       	call   80105a60 <uartinit>
  pinit();         // process table
80102ece:	e8 fd 07 00 00       	call   801036d0 <pinit>
  tvinit();        // trap vectors
80102ed3:	e8 f8 27 00 00       	call   801056d0 <tvinit>
  binit();         // buffer cache
80102ed8:	e8 63 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102edd:	e8 5e de ff ff       	call   80100d40 <fileinit>
  ideinit();       // disk 
80102ee2:	e8 e9 f0 ff ff       	call   80101fd0 <ideinit>
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ee7:	83 c4 0c             	add    $0xc,%esp
80102eea:	68 8a 00 00 00       	push   $0x8a
80102eef:	68 8c a4 10 80       	push   $0x8010a48c
80102ef4:	68 00 70 00 80       	push   $0x80007000
80102ef9:	e8 f2 15 00 00       	call   801044f0 <memmove>
  for(c = cpus; c < cpus+ncpu; c++){
80102efe:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f05:	00 00 00 
80102f08:	83 c4 10             	add    $0x10,%esp
80102f0b:	05 80 27 11 80       	add    $0x80112780,%eax
80102f10:	39 d8                	cmp    %ebx,%eax
80102f12:	76 6f                	jbe    80102f83 <main+0x103>
80102f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102f18:	e8 d3 07 00 00       	call   801036f0 <mycpu>
80102f1d:	39 d8                	cmp    %ebx,%eax
80102f1f:	74 49                	je     80102f6a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f21:	e8 6a f5 ff ff       	call   80102490 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f26:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80102f2b:	c7 05 f8 6f 00 80 60 	movl   $0x80102e60,0x80006ff8
80102f32:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f35:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f3c:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f3f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f44:	0f b6 03             	movzbl (%ebx),%eax
80102f47:	83 ec 08             	sub    $0x8,%esp
80102f4a:	68 00 70 00 00       	push   $0x7000
80102f4f:	50                   	push   %eax
80102f50:	e8 fb f7 ff ff       	call   80102750 <lapicstartap>
80102f55:	83 c4 10             	add    $0x10,%esp
80102f58:	90                   	nop
80102f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f60:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f66:	85 c0                	test   %eax,%eax
80102f68:	74 f6                	je     80102f60 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f6a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f71:	00 00 00 
80102f74:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f7a:	05 80 27 11 80       	add    $0x80112780,%eax
80102f7f:	39 c3                	cmp    %eax,%ebx
80102f81:	72 95                	jb     80102f18 <main+0x98>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f83:	83 ec 08             	sub    $0x8,%esp
80102f86:	68 00 00 00 8e       	push   $0x8e000000
80102f8b:	68 00 00 40 80       	push   $0x80400000
80102f90:	e8 9b f4 ff ff       	call   80102430 <kinit2>
  userinit();      // first user process
80102f95:	e8 26 08 00 00       	call   801037c0 <userinit>
  mpmain();        // finish this processor's setup
80102f9a:	e8 81 fe ff ff       	call   80102e20 <mpmain>
80102f9f:	90                   	nop

80102fa0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	57                   	push   %edi
80102fa4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fa5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102fab:	53                   	push   %ebx
  e = addr+len;
80102fac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102faf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102fb2:	39 de                	cmp    %ebx,%esi
80102fb4:	73 40                	jae    80102ff6 <mpsearch1+0x56>
80102fb6:	8d 76 00             	lea    0x0(%esi),%esi
80102fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fc0:	83 ec 04             	sub    $0x4,%esp
80102fc3:	8d 7e 10             	lea    0x10(%esi),%edi
80102fc6:	6a 04                	push   $0x4
80102fc8:	68 38 74 10 80       	push   $0x80107438
80102fcd:	56                   	push   %esi
80102fce:	e8 bd 14 00 00       	call   80104490 <memcmp>
80102fd3:	83 c4 10             	add    $0x10,%esp
80102fd6:	85 c0                	test   %eax,%eax
80102fd8:	75 16                	jne    80102ff0 <mpsearch1+0x50>
80102fda:	8d 7e 10             	lea    0x10(%esi),%edi
80102fdd:	89 f2                	mov    %esi,%edx
80102fdf:	90                   	nop
    sum += addr[i];
80102fe0:	0f b6 0a             	movzbl (%edx),%ecx
80102fe3:	83 c2 01             	add    $0x1,%edx
80102fe6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80102fe8:	39 fa                	cmp    %edi,%edx
80102fea:	75 f4                	jne    80102fe0 <mpsearch1+0x40>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fec:	84 c0                	test   %al,%al
80102fee:	74 10                	je     80103000 <mpsearch1+0x60>
  for(p = addr; p < e; p += sizeof(struct mp))
80102ff0:	39 fb                	cmp    %edi,%ebx
80102ff2:	89 fe                	mov    %edi,%esi
80102ff4:	77 ca                	ja     80102fc0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80102ff6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102ff9:	31 c0                	xor    %eax,%eax
}
80102ffb:	5b                   	pop    %ebx
80102ffc:	5e                   	pop    %esi
80102ffd:	5f                   	pop    %edi
80102ffe:	5d                   	pop    %ebp
80102fff:	c3                   	ret    
80103000:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103003:	89 f0                	mov    %esi,%eax
80103005:	5b                   	pop    %ebx
80103006:	5e                   	pop    %esi
80103007:	5f                   	pop    %edi
80103008:	5d                   	pop    %ebp
80103009:	c3                   	ret    
8010300a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103010 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	57                   	push   %edi
80103014:	56                   	push   %esi
80103015:	53                   	push   %ebx
80103016:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103019:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103020:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103027:	c1 e0 08             	shl    $0x8,%eax
8010302a:	09 d0                	or     %edx,%eax
8010302c:	c1 e0 04             	shl    $0x4,%eax
8010302f:	85 c0                	test   %eax,%eax
80103031:	75 1b                	jne    8010304e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103033:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010303a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103041:	c1 e0 08             	shl    $0x8,%eax
80103044:	09 d0                	or     %edx,%eax
80103046:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103049:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010304e:	ba 00 04 00 00       	mov    $0x400,%edx
80103053:	e8 48 ff ff ff       	call   80102fa0 <mpsearch1>
80103058:	85 c0                	test   %eax,%eax
8010305a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010305d:	0f 84 37 01 00 00    	je     8010319a <mpinit+0x18a>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103063:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103066:	8b 58 04             	mov    0x4(%eax),%ebx
80103069:	85 db                	test   %ebx,%ebx
8010306b:	0f 84 43 01 00 00    	je     801031b4 <mpinit+0x1a4>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103071:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103077:	83 ec 04             	sub    $0x4,%esp
8010307a:	6a 04                	push   $0x4
8010307c:	68 55 74 10 80       	push   $0x80107455
80103081:	56                   	push   %esi
80103082:	e8 09 14 00 00       	call   80104490 <memcmp>
80103087:	83 c4 10             	add    $0x10,%esp
8010308a:	85 c0                	test   %eax,%eax
8010308c:	0f 85 22 01 00 00    	jne    801031b4 <mpinit+0x1a4>
  if(conf->version != 1 && conf->version != 4)
80103092:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103099:	3c 01                	cmp    $0x1,%al
8010309b:	74 08                	je     801030a5 <mpinit+0x95>
8010309d:	3c 04                	cmp    $0x4,%al
8010309f:	0f 85 0f 01 00 00    	jne    801031b4 <mpinit+0x1a4>
  if(sum((uchar*)conf, conf->length) != 0)
801030a5:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801030ac:	85 ff                	test   %edi,%edi
801030ae:	74 21                	je     801030d1 <mpinit+0xc1>
801030b0:	31 d2                	xor    %edx,%edx
801030b2:	31 c0                	xor    %eax,%eax
801030b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801030b8:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
801030bf:	80 
  for(i=0; i<len; i++)
801030c0:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801030c3:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801030c5:	39 c7                	cmp    %eax,%edi
801030c7:	75 ef                	jne    801030b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801030c9:	84 d2                	test   %dl,%dl
801030cb:	0f 85 e3 00 00 00    	jne    801031b4 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030d1:	85 f6                	test   %esi,%esi
801030d3:	0f 84 db 00 00 00    	je     801031b4 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801030d9:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801030df:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030e4:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801030eb:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801030f1:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030f6:	01 d6                	add    %edx,%esi
801030f8:	90                   	nop
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	39 c6                	cmp    %eax,%esi
80103102:	76 23                	jbe    80103127 <mpinit+0x117>
80103104:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
80103107:	80 fa 04             	cmp    $0x4,%dl
8010310a:	0f 87 c0 00 00 00    	ja     801031d0 <mpinit+0x1c0>
80103110:	ff 24 95 7c 74 10 80 	jmp    *-0x7fef8b84(,%edx,4)
80103117:	89 f6                	mov    %esi,%esi
80103119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103120:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103123:	39 c6                	cmp    %eax,%esi
80103125:	77 dd                	ja     80103104 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103127:	85 db                	test   %ebx,%ebx
80103129:	0f 84 92 00 00 00    	je     801031c1 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010312f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103132:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103136:	74 15                	je     8010314d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103138:	ba 22 00 00 00       	mov    $0x22,%edx
8010313d:	b8 70 00 00 00       	mov    $0x70,%eax
80103142:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103143:	ba 23 00 00 00       	mov    $0x23,%edx
80103148:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103149:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010314c:	ee                   	out    %al,(%dx)
  }
}
8010314d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103150:	5b                   	pop    %ebx
80103151:	5e                   	pop    %esi
80103152:	5f                   	pop    %edi
80103153:	5d                   	pop    %ebp
80103154:	c3                   	ret    
80103155:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103158:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010315e:	83 f9 07             	cmp    $0x7,%ecx
80103161:	7f 19                	jg     8010317c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103163:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103167:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010316d:	83 c1 01             	add    $0x1,%ecx
80103170:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103176:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
8010317c:	83 c0 14             	add    $0x14,%eax
      continue;
8010317f:	e9 7c ff ff ff       	jmp    80103100 <mpinit+0xf0>
80103184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103188:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010318c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010318f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
80103195:	e9 66 ff ff ff       	jmp    80103100 <mpinit+0xf0>
  return mpsearch1(0xF0000, 0x10000);
8010319a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010319f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031a4:	e8 f7 fd ff ff       	call   80102fa0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031a9:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801031ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031ae:	0f 85 af fe ff ff    	jne    80103063 <mpinit+0x53>
    panic("Expect to run on an SMP");
801031b4:	83 ec 0c             	sub    $0xc,%esp
801031b7:	68 3d 74 10 80       	push   $0x8010743d
801031bc:	e8 af d1 ff ff       	call   80100370 <panic>
    panic("Didn't find a suitable machine");
801031c1:	83 ec 0c             	sub    $0xc,%esp
801031c4:	68 5c 74 10 80       	push   $0x8010745c
801031c9:	e8 a2 d1 ff ff       	call   80100370 <panic>
801031ce:	66 90                	xchg   %ax,%ax
      ismp = 0;
801031d0:	31 db                	xor    %ebx,%ebx
801031d2:	e9 30 ff ff ff       	jmp    80103107 <mpinit+0xf7>
801031d7:	66 90                	xchg   %ax,%ax
801031d9:	66 90                	xchg   %ax,%ax
801031db:	66 90                	xchg   %ax,%ax
801031dd:	66 90                	xchg   %ax,%ax
801031df:	90                   	nop

801031e0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801031e0:	55                   	push   %ebp
801031e1:	ba 21 00 00 00       	mov    $0x21,%edx
801031e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031eb:	89 e5                	mov    %esp,%ebp
801031ed:	ee                   	out    %al,(%dx)
801031ee:	ba a1 00 00 00       	mov    $0xa1,%edx
801031f3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031f4:	5d                   	pop    %ebp
801031f5:	c3                   	ret    
801031f6:	66 90                	xchg   %ax,%ax
801031f8:	66 90                	xchg   %ax,%ax
801031fa:	66 90                	xchg   %ax,%ax
801031fc:	66 90                	xchg   %ax,%ax
801031fe:	66 90                	xchg   %ax,%ax

80103200 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	57                   	push   %edi
80103204:	56                   	push   %esi
80103205:	53                   	push   %ebx
80103206:	83 ec 0c             	sub    $0xc,%esp
80103209:	8b 75 08             	mov    0x8(%ebp),%esi
8010320c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010320f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103215:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010321b:	e8 40 db ff ff       	call   80100d60 <filealloc>
80103220:	85 c0                	test   %eax,%eax
80103222:	89 06                	mov    %eax,(%esi)
80103224:	0f 84 a8 00 00 00    	je     801032d2 <pipealloc+0xd2>
8010322a:	e8 31 db ff ff       	call   80100d60 <filealloc>
8010322f:	85 c0                	test   %eax,%eax
80103231:	89 03                	mov    %eax,(%ebx)
80103233:	0f 84 87 00 00 00    	je     801032c0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103239:	e8 52 f2 ff ff       	call   80102490 <kalloc>
8010323e:	85 c0                	test   %eax,%eax
80103240:	89 c7                	mov    %eax,%edi
80103242:	0f 84 b0 00 00 00    	je     801032f8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103248:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
8010324b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103252:	00 00 00 
  p->writeopen = 1;
80103255:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010325c:	00 00 00 
  p->nwrite = 0;
8010325f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103266:	00 00 00 
  p->nread = 0;
80103269:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103270:	00 00 00 
  initlock(&p->lock, "pipe");
80103273:	68 90 74 10 80       	push   $0x80107490
80103278:	50                   	push   %eax
80103279:	e8 52 0f 00 00       	call   801041d0 <initlock>
  (*f0)->type = FD_PIPE;
8010327e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103280:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103283:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103289:	8b 06                	mov    (%esi),%eax
8010328b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010328f:	8b 06                	mov    (%esi),%eax
80103291:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103295:	8b 06                	mov    (%esi),%eax
80103297:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010329a:	8b 03                	mov    (%ebx),%eax
8010329c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801032a2:	8b 03                	mov    (%ebx),%eax
801032a4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801032a8:	8b 03                	mov    (%ebx),%eax
801032aa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801032ae:	8b 03                	mov    (%ebx),%eax
801032b0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801032b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801032b6:	31 c0                	xor    %eax,%eax
}
801032b8:	5b                   	pop    %ebx
801032b9:	5e                   	pop    %esi
801032ba:	5f                   	pop    %edi
801032bb:	5d                   	pop    %ebp
801032bc:	c3                   	ret    
801032bd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801032c0:	8b 06                	mov    (%esi),%eax
801032c2:	85 c0                	test   %eax,%eax
801032c4:	74 1e                	je     801032e4 <pipealloc+0xe4>
    fileclose(*f0);
801032c6:	83 ec 0c             	sub    $0xc,%esp
801032c9:	50                   	push   %eax
801032ca:	e8 51 db ff ff       	call   80100e20 <fileclose>
801032cf:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032d2:	8b 03                	mov    (%ebx),%eax
801032d4:	85 c0                	test   %eax,%eax
801032d6:	74 0c                	je     801032e4 <pipealloc+0xe4>
    fileclose(*f1);
801032d8:	83 ec 0c             	sub    $0xc,%esp
801032db:	50                   	push   %eax
801032dc:	e8 3f db ff ff       	call   80100e20 <fileclose>
801032e1:	83 c4 10             	add    $0x10,%esp
}
801032e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032ec:	5b                   	pop    %ebx
801032ed:	5e                   	pop    %esi
801032ee:	5f                   	pop    %edi
801032ef:	5d                   	pop    %ebp
801032f0:	c3                   	ret    
801032f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801032f8:	8b 06                	mov    (%esi),%eax
801032fa:	85 c0                	test   %eax,%eax
801032fc:	75 c8                	jne    801032c6 <pipealloc+0xc6>
801032fe:	eb d2                	jmp    801032d2 <pipealloc+0xd2>

80103300 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	56                   	push   %esi
80103304:	53                   	push   %ebx
80103305:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103308:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010330b:	83 ec 0c             	sub    $0xc,%esp
8010330e:	53                   	push   %ebx
8010330f:	e8 bc 0f 00 00       	call   801042d0 <acquire>
  if(writable){
80103314:	83 c4 10             	add    $0x10,%esp
80103317:	85 f6                	test   %esi,%esi
80103319:	74 45                	je     80103360 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010331b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103321:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103324:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010332b:	00 00 00 
    wakeup(&p->nread);
8010332e:	50                   	push   %eax
8010332f:	e8 dc 0b 00 00       	call   80103f10 <wakeup>
80103334:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103337:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010333d:	85 d2                	test   %edx,%edx
8010333f:	75 0a                	jne    8010334b <pipeclose+0x4b>
80103341:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103347:	85 c0                	test   %eax,%eax
80103349:	74 35                	je     80103380 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010334b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010334e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103351:	5b                   	pop    %ebx
80103352:	5e                   	pop    %esi
80103353:	5d                   	pop    %ebp
    release(&p->lock);
80103354:	e9 97 10 00 00       	jmp    801043f0 <release>
80103359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103360:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103366:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103369:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103370:	00 00 00 
    wakeup(&p->nwrite);
80103373:	50                   	push   %eax
80103374:	e8 97 0b 00 00       	call   80103f10 <wakeup>
80103379:	83 c4 10             	add    $0x10,%esp
8010337c:	eb b9                	jmp    80103337 <pipeclose+0x37>
8010337e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103380:	83 ec 0c             	sub    $0xc,%esp
80103383:	53                   	push   %ebx
80103384:	e8 67 10 00 00       	call   801043f0 <release>
    kfree((char*)p);
80103389:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010338c:	83 c4 10             	add    $0x10,%esp
}
8010338f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103392:	5b                   	pop    %ebx
80103393:	5e                   	pop    %esi
80103394:	5d                   	pop    %ebp
    kfree((char*)p);
80103395:	e9 46 ef ff ff       	jmp    801022e0 <kfree>
8010339a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801033a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	57                   	push   %edi
801033a4:	56                   	push   %esi
801033a5:	53                   	push   %ebx
801033a6:	83 ec 28             	sub    $0x28,%esp
801033a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801033ac:	53                   	push   %ebx
801033ad:	e8 1e 0f 00 00       	call   801042d0 <acquire>
  for(i = 0; i < n; i++){
801033b2:	8b 45 10             	mov    0x10(%ebp),%eax
801033b5:	83 c4 10             	add    $0x10,%esp
801033b8:	85 c0                	test   %eax,%eax
801033ba:	0f 8e ca 00 00 00    	jle    8010348a <pipewrite+0xea>
801033c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801033c3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033c9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801033cf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801033d2:	03 4d 10             	add    0x10(%ebp),%ecx
801033d5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033d8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801033de:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801033e4:	39 d0                	cmp    %edx,%eax
801033e6:	75 71                	jne    80103459 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801033e8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801033ee:	85 c0                	test   %eax,%eax
801033f0:	74 4e                	je     80103440 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033f2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801033f8:	eb 3a                	jmp    80103434 <pipewrite+0x94>
801033fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103400:	83 ec 0c             	sub    $0xc,%esp
80103403:	57                   	push   %edi
80103404:	e8 07 0b 00 00       	call   80103f10 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103409:	5a                   	pop    %edx
8010340a:	59                   	pop    %ecx
8010340b:	53                   	push   %ebx
8010340c:	56                   	push   %esi
8010340d:	e8 3e 09 00 00       	call   80103d50 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103412:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103418:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010341e:	83 c4 10             	add    $0x10,%esp
80103421:	05 00 02 00 00       	add    $0x200,%eax
80103426:	39 c2                	cmp    %eax,%edx
80103428:	75 36                	jne    80103460 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010342a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103430:	85 c0                	test   %eax,%eax
80103432:	74 0c                	je     80103440 <pipewrite+0xa0>
80103434:	e8 57 03 00 00       	call   80103790 <myproc>
80103439:	8b 40 24             	mov    0x24(%eax),%eax
8010343c:	85 c0                	test   %eax,%eax
8010343e:	74 c0                	je     80103400 <pipewrite+0x60>
        release(&p->lock);
80103440:	83 ec 0c             	sub    $0xc,%esp
80103443:	53                   	push   %ebx
80103444:	e8 a7 0f 00 00       	call   801043f0 <release>
        return -1;
80103449:	83 c4 10             	add    $0x10,%esp
8010344c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103451:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103454:	5b                   	pop    %ebx
80103455:	5e                   	pop    %esi
80103456:	5f                   	pop    %edi
80103457:	5d                   	pop    %ebp
80103458:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103459:	89 c2                	mov    %eax,%edx
8010345b:	90                   	nop
8010345c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103460:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103463:	8d 42 01             	lea    0x1(%edx),%eax
80103466:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010346c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103472:	0f b6 0e             	movzbl (%esi),%ecx
80103475:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
80103479:	89 f1                	mov    %esi,%ecx
8010347b:	83 c1 01             	add    $0x1,%ecx
  for(i = 0; i < n; i++){
8010347e:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103481:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103484:	0f 85 4e ff ff ff    	jne    801033d8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010348a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	50                   	push   %eax
80103494:	e8 77 0a 00 00       	call   80103f10 <wakeup>
  release(&p->lock);
80103499:	89 1c 24             	mov    %ebx,(%esp)
8010349c:	e8 4f 0f 00 00       	call   801043f0 <release>
  return n;
801034a1:	83 c4 10             	add    $0x10,%esp
801034a4:	8b 45 10             	mov    0x10(%ebp),%eax
801034a7:	eb a8                	jmp    80103451 <pipewrite+0xb1>
801034a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801034b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	57                   	push   %edi
801034b4:	56                   	push   %esi
801034b5:	53                   	push   %ebx
801034b6:	83 ec 18             	sub    $0x18,%esp
801034b9:	8b 75 08             	mov    0x8(%ebp),%esi
801034bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801034bf:	56                   	push   %esi
801034c0:	e8 0b 0e 00 00       	call   801042d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034c5:	83 c4 10             	add    $0x10,%esp
801034c8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801034ce:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801034d4:	75 6a                	jne    80103540 <piperead+0x90>
801034d6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801034dc:	85 db                	test   %ebx,%ebx
801034de:	0f 84 c4 00 00 00    	je     801035a8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801034e4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801034ea:	eb 2d                	jmp    80103519 <piperead+0x69>
801034ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034f0:	83 ec 08             	sub    $0x8,%esp
801034f3:	56                   	push   %esi
801034f4:	53                   	push   %ebx
801034f5:	e8 56 08 00 00       	call   80103d50 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034fa:	83 c4 10             	add    $0x10,%esp
801034fd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103503:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103509:	75 35                	jne    80103540 <piperead+0x90>
8010350b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103511:	85 d2                	test   %edx,%edx
80103513:	0f 84 8f 00 00 00    	je     801035a8 <piperead+0xf8>
    if(myproc()->killed){
80103519:	e8 72 02 00 00       	call   80103790 <myproc>
8010351e:	8b 48 24             	mov    0x24(%eax),%ecx
80103521:	85 c9                	test   %ecx,%ecx
80103523:	74 cb                	je     801034f0 <piperead+0x40>
      release(&p->lock);
80103525:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103528:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010352d:	56                   	push   %esi
8010352e:	e8 bd 0e 00 00       	call   801043f0 <release>
      return -1;
80103533:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103536:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103539:	89 d8                	mov    %ebx,%eax
8010353b:	5b                   	pop    %ebx
8010353c:	5e                   	pop    %esi
8010353d:	5f                   	pop    %edi
8010353e:	5d                   	pop    %ebp
8010353f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103540:	8b 45 10             	mov    0x10(%ebp),%eax
80103543:	85 c0                	test   %eax,%eax
80103545:	7e 61                	jle    801035a8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103547:	31 db                	xor    %ebx,%ebx
80103549:	eb 13                	jmp    8010355e <piperead+0xae>
8010354b:	90                   	nop
8010354c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103550:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103556:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010355c:	74 1f                	je     8010357d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010355e:	8d 41 01             	lea    0x1(%ecx),%eax
80103561:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103567:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010356d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103572:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103575:	83 c3 01             	add    $0x1,%ebx
80103578:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010357b:	75 d3                	jne    80103550 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010357d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103583:	83 ec 0c             	sub    $0xc,%esp
80103586:	50                   	push   %eax
80103587:	e8 84 09 00 00       	call   80103f10 <wakeup>
  release(&p->lock);
8010358c:	89 34 24             	mov    %esi,(%esp)
8010358f:	e8 5c 0e 00 00       	call   801043f0 <release>
  return i;
80103594:	83 c4 10             	add    $0x10,%esp
}
80103597:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010359a:	89 d8                	mov    %ebx,%eax
8010359c:	5b                   	pop    %ebx
8010359d:	5e                   	pop    %esi
8010359e:	5f                   	pop    %edi
8010359f:	5d                   	pop    %ebp
801035a0:	c3                   	ret    
801035a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
801035a8:	31 db                	xor    %ebx,%ebx
801035aa:	eb d1                	jmp    8010357d <piperead+0xcd>
801035ac:	66 90                	xchg   %ax,%ax
801035ae:	66 90                	xchg   %ax,%ax

801035b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035b4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801035b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801035bc:	68 20 2d 11 80       	push   $0x80112d20
801035c1:	e8 0a 0d 00 00       	call   801042d0 <acquire>
801035c6:	83 c4 10             	add    $0x10,%esp
801035c9:	eb 10                	jmp    801035db <allocproc+0x2b>
801035cb:	90                   	nop
801035cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035d0:	83 c3 7c             	add    $0x7c,%ebx
801035d3:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801035d9:	73 75                	jae    80103650 <allocproc+0xa0>
    if(p->state == UNUSED)
801035db:	8b 43 0c             	mov    0xc(%ebx),%eax
801035de:	85 c0                	test   %eax,%eax
801035e0:	75 ee                	jne    801035d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801035e2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801035e7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801035ea:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801035f1:	8d 50 01             	lea    0x1(%eax),%edx
801035f4:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801035f7:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801035fc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103602:	e8 e9 0d 00 00       	call   801043f0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103607:	e8 84 ee ff ff       	call   80102490 <kalloc>
8010360c:	83 c4 10             	add    $0x10,%esp
8010360f:	85 c0                	test   %eax,%eax
80103611:	89 43 08             	mov    %eax,0x8(%ebx)
80103614:	74 53                	je     80103669 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103616:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010361c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010361f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103624:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103627:	c7 40 14 c2 56 10 80 	movl   $0x801056c2,0x14(%eax)
  p->context = (struct context*)sp;
8010362e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103631:	6a 14                	push   $0x14
80103633:	6a 00                	push   $0x0
80103635:	50                   	push   %eax
80103636:	e8 05 0e 00 00       	call   80104440 <memset>
  p->context->eip = (uint)forkret;
8010363b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010363e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103641:	c7 40 10 80 36 10 80 	movl   $0x80103680,0x10(%eax)
}
80103648:	89 d8                	mov    %ebx,%eax
8010364a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010364d:	c9                   	leave  
8010364e:	c3                   	ret    
8010364f:	90                   	nop
  release(&ptable.lock);
80103650:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103653:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103655:	68 20 2d 11 80       	push   $0x80112d20
8010365a:	e8 91 0d 00 00       	call   801043f0 <release>
}
8010365f:	89 d8                	mov    %ebx,%eax
  return 0;
80103661:	83 c4 10             	add    $0x10,%esp
}
80103664:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103667:	c9                   	leave  
80103668:	c3                   	ret    
    p->state = UNUSED;
80103669:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103670:	31 db                	xor    %ebx,%ebx
80103672:	eb d4                	jmp    80103648 <allocproc+0x98>
80103674:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010367a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103680 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103686:	68 20 2d 11 80       	push   $0x80112d20
8010368b:	e8 60 0d 00 00       	call   801043f0 <release>

  if (first) {
80103690:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103695:	83 c4 10             	add    $0x10,%esp
80103698:	85 c0                	test   %eax,%eax
8010369a:	75 04                	jne    801036a0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010369c:	c9                   	leave  
8010369d:	c3                   	ret    
8010369e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801036a0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801036a3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801036aa:	00 00 00 
    iinit(ROOTDEV);
801036ad:	6a 01                	push   $0x1
801036af:	e8 bc dd ff ff       	call   80101470 <iinit>
    initlog(ROOTDEV);
801036b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801036bb:	e8 10 f4 ff ff       	call   80102ad0 <initlog>
801036c0:	83 c4 10             	add    $0x10,%esp
}
801036c3:	c9                   	leave  
801036c4:	c3                   	ret    
801036c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036d0 <pinit>:
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801036d6:	68 95 74 10 80       	push   $0x80107495
801036db:	68 20 2d 11 80       	push   $0x80112d20
801036e0:	e8 eb 0a 00 00       	call   801041d0 <initlock>
}
801036e5:	83 c4 10             	add    $0x10,%esp
801036e8:	c9                   	leave  
801036e9:	c3                   	ret    
801036ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801036f0 <mycpu>:
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	56                   	push   %esi
801036f4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801036f5:	9c                   	pushf  
801036f6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801036f7:	f6 c4 02             	test   $0x2,%ah
801036fa:	75 5e                	jne    8010375a <mycpu+0x6a>
  apicid = lapicid();
801036fc:	e8 ff ef ff ff       	call   80102700 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103701:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103707:	85 f6                	test   %esi,%esi
80103709:	7e 42                	jle    8010374d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010370b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103712:	39 d0                	cmp    %edx,%eax
80103714:	74 30                	je     80103746 <mycpu+0x56>
80103716:	b9 30 28 11 80       	mov    $0x80112830,%ecx
8010371b:	31 d2                	xor    %edx,%edx
8010371d:	8d 76 00             	lea    0x0(%esi),%esi
  for (i = 0; i < ncpu; ++i) {
80103720:	83 c2 01             	add    $0x1,%edx
80103723:	39 f2                	cmp    %esi,%edx
80103725:	74 26                	je     8010374d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103727:	0f b6 19             	movzbl (%ecx),%ebx
8010372a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103730:	39 d8                	cmp    %ebx,%eax
80103732:	75 ec                	jne    80103720 <mycpu+0x30>
80103734:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010373a:	05 80 27 11 80       	add    $0x80112780,%eax
}
8010373f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103742:	5b                   	pop    %ebx
80103743:	5e                   	pop    %esi
80103744:	5d                   	pop    %ebp
80103745:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103746:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
8010374b:	eb f2                	jmp    8010373f <mycpu+0x4f>
  panic("unknown apicid\n");
8010374d:	83 ec 0c             	sub    $0xc,%esp
80103750:	68 9c 74 10 80       	push   $0x8010749c
80103755:	e8 16 cc ff ff       	call   80100370 <panic>
    panic("mycpu called with interrupts enabled\n");
8010375a:	83 ec 0c             	sub    $0xc,%esp
8010375d:	68 78 75 10 80       	push   $0x80107578
80103762:	e8 09 cc ff ff       	call   80100370 <panic>
80103767:	89 f6                	mov    %esi,%esi
80103769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103770 <cpuid>:
cpuid() {
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103776:	e8 75 ff ff ff       	call   801036f0 <mycpu>
8010377b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103780:	c9                   	leave  
  return mycpu()-cpus;
80103781:	c1 f8 04             	sar    $0x4,%eax
80103784:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010378a:	c3                   	ret    
8010378b:	90                   	nop
8010378c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103790 <myproc>:
myproc(void) {
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	53                   	push   %ebx
80103794:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103797:	e8 f4 0a 00 00       	call   80104290 <pushcli>
  c = mycpu();
8010379c:	e8 4f ff ff ff       	call   801036f0 <mycpu>
  p = c->proc;
801037a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801037a7:	e8 d4 0b 00 00       	call   80104380 <popcli>
}
801037ac:	83 c4 04             	add    $0x4,%esp
801037af:	89 d8                	mov    %ebx,%eax
801037b1:	5b                   	pop    %ebx
801037b2:	5d                   	pop    %ebp
801037b3:	c3                   	ret    
801037b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801037c0 <userinit>:
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	53                   	push   %ebx
801037c4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801037c7:	e8 e4 fd ff ff       	call   801035b0 <allocproc>
801037cc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801037ce:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801037d3:	e8 c8 34 00 00       	call   80106ca0 <setupkvm>
801037d8:	85 c0                	test   %eax,%eax
801037da:	89 43 04             	mov    %eax,0x4(%ebx)
801037dd:	0f 84 bd 00 00 00    	je     801038a0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801037e3:	83 ec 04             	sub    $0x4,%esp
801037e6:	68 2c 00 00 00       	push   $0x2c
801037eb:	68 60 a4 10 80       	push   $0x8010a460
801037f0:	50                   	push   %eax
801037f1:	e8 ca 31 00 00       	call   801069c0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801037f6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801037f9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801037ff:	6a 4c                	push   $0x4c
80103801:	6a 00                	push   $0x0
80103803:	ff 73 18             	pushl  0x18(%ebx)
80103806:	e8 35 0c 00 00       	call   80104440 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010380b:	8b 43 18             	mov    0x18(%ebx),%eax
8010380e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103813:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103818:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010381b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010381f:	8b 43 18             	mov    0x18(%ebx),%eax
80103822:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103826:	8b 43 18             	mov    0x18(%ebx),%eax
80103829:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010382d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103831:	8b 43 18             	mov    0x18(%ebx),%eax
80103834:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103838:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010383c:	8b 43 18             	mov    0x18(%ebx),%eax
8010383f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103846:	8b 43 18             	mov    0x18(%ebx),%eax
80103849:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103850:	8b 43 18             	mov    0x18(%ebx),%eax
80103853:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010385a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010385d:	6a 10                	push   $0x10
8010385f:	68 c5 74 10 80       	push   $0x801074c5
80103864:	50                   	push   %eax
80103865:	e8 b6 0d 00 00       	call   80104620 <safestrcpy>
  p->cwd = namei("/");
8010386a:	c7 04 24 ce 74 10 80 	movl   $0x801074ce,(%esp)
80103871:	e8 4a e6 ff ff       	call   80101ec0 <namei>
80103876:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103879:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103880:	e8 4b 0a 00 00       	call   801042d0 <acquire>
  p->state = RUNNABLE;
80103885:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010388c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103893:	e8 58 0b 00 00       	call   801043f0 <release>
}
80103898:	83 c4 10             	add    $0x10,%esp
8010389b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010389e:	c9                   	leave  
8010389f:	c3                   	ret    
    panic("userinit: out of memory?");
801038a0:	83 ec 0c             	sub    $0xc,%esp
801038a3:	68 ac 74 10 80       	push   $0x801074ac
801038a8:	e8 c3 ca ff ff       	call   80100370 <panic>
801038ad:	8d 76 00             	lea    0x0(%esi),%esi

801038b0 <growproc>:
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	56                   	push   %esi
801038b4:	53                   	push   %ebx
801038b5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801038b8:	e8 d3 09 00 00       	call   80104290 <pushcli>
  c = mycpu();
801038bd:	e8 2e fe ff ff       	call   801036f0 <mycpu>
  p = c->proc;
801038c2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801038c8:	e8 b3 0a 00 00       	call   80104380 <popcli>
  if(n > 0){
801038cd:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
801038d0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801038d2:	7e 34                	jle    80103908 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038d4:	83 ec 04             	sub    $0x4,%esp
801038d7:	01 c6                	add    %eax,%esi
801038d9:	56                   	push   %esi
801038da:	50                   	push   %eax
801038db:	ff 73 04             	pushl  0x4(%ebx)
801038de:	e8 1d 32 00 00       	call   80106b00 <allocuvm>
801038e3:	83 c4 10             	add    $0x10,%esp
801038e6:	85 c0                	test   %eax,%eax
801038e8:	74 36                	je     80103920 <growproc+0x70>
  switchuvm(curproc);
801038ea:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801038ed:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801038ef:	53                   	push   %ebx
801038f0:	e8 bb 2f 00 00       	call   801068b0 <switchuvm>
  return 0;
801038f5:	83 c4 10             	add    $0x10,%esp
801038f8:	31 c0                	xor    %eax,%eax
}
801038fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038fd:	5b                   	pop    %ebx
801038fe:	5e                   	pop    %esi
801038ff:	5d                   	pop    %ebp
80103900:	c3                   	ret    
80103901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  } else if(n < 0){
80103908:	74 e0                	je     801038ea <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010390a:	83 ec 04             	sub    $0x4,%esp
8010390d:	01 c6                	add    %eax,%esi
8010390f:	56                   	push   %esi
80103910:	50                   	push   %eax
80103911:	ff 73 04             	pushl  0x4(%ebx)
80103914:	e8 d7 32 00 00       	call   80106bf0 <deallocuvm>
80103919:	83 c4 10             	add    $0x10,%esp
8010391c:	85 c0                	test   %eax,%eax
8010391e:	75 ca                	jne    801038ea <growproc+0x3a>
      return -1;
80103920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103925:	eb d3                	jmp    801038fa <growproc+0x4a>
80103927:	89 f6                	mov    %esi,%esi
80103929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103930 <fork>:
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	57                   	push   %edi
80103934:	56                   	push   %esi
80103935:	53                   	push   %ebx
80103936:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103939:	e8 52 09 00 00       	call   80104290 <pushcli>
  c = mycpu();
8010393e:	e8 ad fd ff ff       	call   801036f0 <mycpu>
  p = c->proc;
80103943:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103949:	e8 32 0a 00 00       	call   80104380 <popcli>
  if((np = allocproc()) == 0){
8010394e:	e8 5d fc ff ff       	call   801035b0 <allocproc>
80103953:	85 c0                	test   %eax,%eax
80103955:	89 c7                	mov    %eax,%edi
80103957:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010395a:	0f 84 b5 00 00 00    	je     80103a15 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103960:	83 ec 08             	sub    $0x8,%esp
80103963:	ff 33                	pushl  (%ebx)
80103965:	ff 73 04             	pushl  0x4(%ebx)
80103968:	e8 03 34 00 00       	call   80106d70 <copyuvm>
8010396d:	83 c4 10             	add    $0x10,%esp
80103970:	85 c0                	test   %eax,%eax
80103972:	89 47 04             	mov    %eax,0x4(%edi)
80103975:	0f 84 a1 00 00 00    	je     80103a1c <fork+0xec>
  np->sz = curproc->sz;
8010397b:	8b 03                	mov    (%ebx),%eax
8010397d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103980:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103982:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103985:	89 c8                	mov    %ecx,%eax
80103987:	8b 79 18             	mov    0x18(%ecx),%edi
8010398a:	8b 73 18             	mov    0x18(%ebx),%esi
8010398d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103992:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103994:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103996:	8b 40 18             	mov    0x18(%eax),%eax
80103999:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
801039a0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801039a4:	85 c0                	test   %eax,%eax
801039a6:	74 13                	je     801039bb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
801039a8:	83 ec 0c             	sub    $0xc,%esp
801039ab:	50                   	push   %eax
801039ac:	e8 1f d4 ff ff       	call   80100dd0 <filedup>
801039b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801039b4:	83 c4 10             	add    $0x10,%esp
801039b7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801039bb:	83 c6 01             	add    $0x1,%esi
801039be:	83 fe 10             	cmp    $0x10,%esi
801039c1:	75 dd                	jne    801039a0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
801039c3:	83 ec 0c             	sub    $0xc,%esp
801039c6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039c9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801039cc:	e8 6f dc ff ff       	call   80101640 <idup>
801039d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039d4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801039d7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039da:	8d 47 6c             	lea    0x6c(%edi),%eax
801039dd:	6a 10                	push   $0x10
801039df:	53                   	push   %ebx
801039e0:	50                   	push   %eax
801039e1:	e8 3a 0c 00 00       	call   80104620 <safestrcpy>
  pid = np->pid;
801039e6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801039e9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039f0:	e8 db 08 00 00       	call   801042d0 <acquire>
  np->state = RUNNABLE;
801039f5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801039fc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a03:	e8 e8 09 00 00       	call   801043f0 <release>
  return pid;
80103a08:	83 c4 10             	add    $0x10,%esp
}
80103a0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a0e:	89 d8                	mov    %ebx,%eax
80103a10:	5b                   	pop    %ebx
80103a11:	5e                   	pop    %esi
80103a12:	5f                   	pop    %edi
80103a13:	5d                   	pop    %ebp
80103a14:	c3                   	ret    
    return -1;
80103a15:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103a1a:	eb ef                	jmp    80103a0b <fork+0xdb>
    kfree(np->kstack);
80103a1c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103a1f:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103a22:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
80103a27:	ff 77 08             	pushl  0x8(%edi)
80103a2a:	e8 b1 e8 ff ff       	call   801022e0 <kfree>
    np->kstack = 0;
80103a2f:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103a36:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103a3d:	83 c4 10             	add    $0x10,%esp
80103a40:	eb c9                	jmp    80103a0b <fork+0xdb>
80103a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a50 <scheduler>:
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	57                   	push   %edi
80103a54:	56                   	push   %esi
80103a55:	53                   	push   %ebx
80103a56:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103a59:	e8 92 fc ff ff       	call   801036f0 <mycpu>
80103a5e:	8d 78 04             	lea    0x4(%eax),%edi
80103a61:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103a63:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103a6a:	00 00 00 
80103a6d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103a70:	fb                   	sti    
    acquire(&ptable.lock);
80103a71:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a74:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103a79:	68 20 2d 11 80       	push   $0x80112d20
80103a7e:	e8 4d 08 00 00       	call   801042d0 <acquire>
80103a83:	83 c4 10             	add    $0x10,%esp
    ran = 0;
80103a86:	31 c0                	xor    %eax,%eax
80103a88:	eb 11                	jmp    80103a9b <scheduler+0x4b>
80103a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a90:	83 c3 7c             	add    $0x7c,%ebx
80103a93:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103a99:	73 4d                	jae    80103ae8 <scheduler+0x98>
      if(p->state != RUNNABLE)
80103a9b:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103a9f:	75 ef                	jne    80103a90 <scheduler+0x40>
      switchuvm(p);
80103aa1:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103aa4:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103aaa:	53                   	push   %ebx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103aab:	83 c3 7c             	add    $0x7c,%ebx
      switchuvm(p);
80103aae:	e8 fd 2d 00 00       	call   801068b0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ab3:	58                   	pop    %eax
80103ab4:	5a                   	pop    %edx
80103ab5:	ff 73 a0             	pushl  -0x60(%ebx)
80103ab8:	57                   	push   %edi
      p->state = RUNNING;
80103ab9:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)
      swtch(&(c->scheduler), p->context);
80103ac0:	e8 b6 0b 00 00       	call   8010467b <swtch>
      switchkvm();
80103ac5:	e8 c6 2d 00 00       	call   80106890 <switchkvm>
      c->proc = 0;
80103aca:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103acd:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
      c->proc = 0;
80103ad3:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ada:	00 00 00 
      ran = 1;
80103add:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ae2:	72 b7                	jb     80103a9b <scheduler+0x4b>
80103ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
80103ae8:	83 ec 0c             	sub    $0xc,%esp
80103aeb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103aee:	68 20 2d 11 80       	push   $0x80112d20
80103af3:	e8 f8 08 00 00       	call   801043f0 <release>
    if (ran == 0){
80103af8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103afb:	83 c4 10             	add    $0x10,%esp
80103afe:	85 c0                	test   %eax,%eax
80103b00:	0f 85 6a ff ff ff    	jne    80103a70 <scheduler+0x20>

// CS 350/550: to solve the 100%-CPU-utilization-when-idling problem - "hlt" instruction puts CPU to sleep
static inline void
halt()
{
    asm volatile("hlt" : : :"memory");
80103b06:	f4                   	hlt    
80103b07:	e9 64 ff ff ff       	jmp    80103a70 <scheduler+0x20>
80103b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b10 <sched>:
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	56                   	push   %esi
80103b14:	53                   	push   %ebx
  pushcli();
80103b15:	e8 76 07 00 00       	call   80104290 <pushcli>
  c = mycpu();
80103b1a:	e8 d1 fb ff ff       	call   801036f0 <mycpu>
  p = c->proc;
80103b1f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b25:	e8 56 08 00 00       	call   80104380 <popcli>
  if(!holding(&ptable.lock))
80103b2a:	83 ec 0c             	sub    $0xc,%esp
80103b2d:	68 20 2d 11 80       	push   $0x80112d20
80103b32:	e8 19 07 00 00       	call   80104250 <holding>
80103b37:	83 c4 10             	add    $0x10,%esp
80103b3a:	85 c0                	test   %eax,%eax
80103b3c:	74 4f                	je     80103b8d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103b3e:	e8 ad fb ff ff       	call   801036f0 <mycpu>
80103b43:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103b4a:	75 68                	jne    80103bb4 <sched+0xa4>
  if(p->state == RUNNING)
80103b4c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103b50:	74 55                	je     80103ba7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b52:	9c                   	pushf  
80103b53:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b54:	f6 c4 02             	test   $0x2,%ah
80103b57:	75 41                	jne    80103b9a <sched+0x8a>
  intena = mycpu()->intena;
80103b59:	e8 92 fb ff ff       	call   801036f0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103b5e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103b61:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103b67:	e8 84 fb ff ff       	call   801036f0 <mycpu>
80103b6c:	83 ec 08             	sub    $0x8,%esp
80103b6f:	ff 70 04             	pushl  0x4(%eax)
80103b72:	53                   	push   %ebx
80103b73:	e8 03 0b 00 00       	call   8010467b <swtch>
  mycpu()->intena = intena;
80103b78:	e8 73 fb ff ff       	call   801036f0 <mycpu>
}
80103b7d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103b80:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b89:	5b                   	pop    %ebx
80103b8a:	5e                   	pop    %esi
80103b8b:	5d                   	pop    %ebp
80103b8c:	c3                   	ret    
    panic("sched ptable.lock");
80103b8d:	83 ec 0c             	sub    $0xc,%esp
80103b90:	68 d0 74 10 80       	push   $0x801074d0
80103b95:	e8 d6 c7 ff ff       	call   80100370 <panic>
    panic("sched interruptible");
80103b9a:	83 ec 0c             	sub    $0xc,%esp
80103b9d:	68 fc 74 10 80       	push   $0x801074fc
80103ba2:	e8 c9 c7 ff ff       	call   80100370 <panic>
    panic("sched running");
80103ba7:	83 ec 0c             	sub    $0xc,%esp
80103baa:	68 ee 74 10 80       	push   $0x801074ee
80103baf:	e8 bc c7 ff ff       	call   80100370 <panic>
    panic("sched locks");
80103bb4:	83 ec 0c             	sub    $0xc,%esp
80103bb7:	68 e2 74 10 80       	push   $0x801074e2
80103bbc:	e8 af c7 ff ff       	call   80100370 <panic>
80103bc1:	eb 0d                	jmp    80103bd0 <exit>
80103bc3:	90                   	nop
80103bc4:	90                   	nop
80103bc5:	90                   	nop
80103bc6:	90                   	nop
80103bc7:	90                   	nop
80103bc8:	90                   	nop
80103bc9:	90                   	nop
80103bca:	90                   	nop
80103bcb:	90                   	nop
80103bcc:	90                   	nop
80103bcd:	90                   	nop
80103bce:	90                   	nop
80103bcf:	90                   	nop

80103bd0 <exit>:
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	57                   	push   %edi
80103bd4:	56                   	push   %esi
80103bd5:	53                   	push   %ebx
80103bd6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103bd9:	e8 b2 06 00 00       	call   80104290 <pushcli>
  c = mycpu();
80103bde:	e8 0d fb ff ff       	call   801036f0 <mycpu>
  p = c->proc;
80103be3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103be9:	e8 92 07 00 00       	call   80104380 <popcli>
  if(curproc == initproc)
80103bee:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103bf4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103bf7:	8d 7e 68             	lea    0x68(%esi),%edi
80103bfa:	0f 84 e7 00 00 00    	je     80103ce7 <exit+0x117>
    if(curproc->ofile[fd]){
80103c00:	8b 03                	mov    (%ebx),%eax
80103c02:	85 c0                	test   %eax,%eax
80103c04:	74 12                	je     80103c18 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103c06:	83 ec 0c             	sub    $0xc,%esp
80103c09:	50                   	push   %eax
80103c0a:	e8 11 d2 ff ff       	call   80100e20 <fileclose>
      curproc->ofile[fd] = 0;
80103c0f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103c15:	83 c4 10             	add    $0x10,%esp
80103c18:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103c1b:	39 fb                	cmp    %edi,%ebx
80103c1d:	75 e1                	jne    80103c00 <exit+0x30>
  begin_op();
80103c1f:	e8 4c ef ff ff       	call   80102b70 <begin_op>
  iput(curproc->cwd);
80103c24:	83 ec 0c             	sub    $0xc,%esp
80103c27:	ff 76 68             	pushl  0x68(%esi)
80103c2a:	e8 71 db ff ff       	call   801017a0 <iput>
  end_op();
80103c2f:	e8 ac ef ff ff       	call   80102be0 <end_op>
  curproc->cwd = 0;
80103c34:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103c3b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c42:	e8 89 06 00 00       	call   801042d0 <acquire>
  wakeup1(curproc->parent);
80103c47:	8b 56 14             	mov    0x14(%esi),%edx
80103c4a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c4d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103c52:	eb 0e                	jmp    80103c62 <exit+0x92>
80103c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c58:	83 c0 7c             	add    $0x7c,%eax
80103c5b:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103c60:	73 1c                	jae    80103c7e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103c62:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103c66:	75 f0                	jne    80103c58 <exit+0x88>
80103c68:	3b 50 20             	cmp    0x20(%eax),%edx
80103c6b:	75 eb                	jne    80103c58 <exit+0x88>
      p->state = RUNNABLE;
80103c6d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c74:	83 c0 7c             	add    $0x7c,%eax
80103c77:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103c7c:	72 e4                	jb     80103c62 <exit+0x92>
      p->parent = initproc;
80103c7e:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
80103c84:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103c89:	eb 10                	jmp    80103c9b <exit+0xcb>
80103c8b:	90                   	nop
80103c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c90:	83 c2 7c             	add    $0x7c,%edx
80103c93:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103c99:	73 33                	jae    80103cce <exit+0xfe>
    if(p->parent == curproc){
80103c9b:	39 72 14             	cmp    %esi,0x14(%edx)
80103c9e:	75 f0                	jne    80103c90 <exit+0xc0>
      if(p->state == ZOMBIE)
80103ca0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103ca4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103ca7:	75 e7                	jne    80103c90 <exit+0xc0>
80103ca9:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103cae:	eb 0a                	jmp    80103cba <exit+0xea>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cb0:	83 c0 7c             	add    $0x7c,%eax
80103cb3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103cb8:	73 d6                	jae    80103c90 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103cba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103cbe:	75 f0                	jne    80103cb0 <exit+0xe0>
80103cc0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103cc3:	75 eb                	jne    80103cb0 <exit+0xe0>
      p->state = RUNNABLE;
80103cc5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103ccc:	eb e2                	jmp    80103cb0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103cce:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103cd5:	e8 36 fe ff ff       	call   80103b10 <sched>
  panic("zombie exit");
80103cda:	83 ec 0c             	sub    $0xc,%esp
80103cdd:	68 1d 75 10 80       	push   $0x8010751d
80103ce2:	e8 89 c6 ff ff       	call   80100370 <panic>
    panic("init exiting");
80103ce7:	83 ec 0c             	sub    $0xc,%esp
80103cea:	68 10 75 10 80       	push   $0x80107510
80103cef:	e8 7c c6 ff ff       	call   80100370 <panic>
80103cf4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103cfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103d00 <yield>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	53                   	push   %ebx
80103d04:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103d07:	68 20 2d 11 80       	push   $0x80112d20
80103d0c:	e8 bf 05 00 00       	call   801042d0 <acquire>
  pushcli();
80103d11:	e8 7a 05 00 00       	call   80104290 <pushcli>
  c = mycpu();
80103d16:	e8 d5 f9 ff ff       	call   801036f0 <mycpu>
  p = c->proc;
80103d1b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d21:	e8 5a 06 00 00       	call   80104380 <popcli>
  myproc()->state = RUNNABLE;
80103d26:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103d2d:	e8 de fd ff ff       	call   80103b10 <sched>
  release(&ptable.lock);
80103d32:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d39:	e8 b2 06 00 00       	call   801043f0 <release>
}
80103d3e:	83 c4 10             	add    $0x10,%esp
80103d41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d44:	c9                   	leave  
80103d45:	c3                   	ret    
80103d46:	8d 76 00             	lea    0x0(%esi),%esi
80103d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d50 <sleep>:
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	57                   	push   %edi
80103d54:	56                   	push   %esi
80103d55:	53                   	push   %ebx
80103d56:	83 ec 0c             	sub    $0xc,%esp
80103d59:	8b 7d 08             	mov    0x8(%ebp),%edi
80103d5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103d5f:	e8 2c 05 00 00       	call   80104290 <pushcli>
  c = mycpu();
80103d64:	e8 87 f9 ff ff       	call   801036f0 <mycpu>
  p = c->proc;
80103d69:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d6f:	e8 0c 06 00 00       	call   80104380 <popcli>
  if(p == 0)
80103d74:	85 db                	test   %ebx,%ebx
80103d76:	0f 84 87 00 00 00    	je     80103e03 <sleep+0xb3>
  if(lk == 0)
80103d7c:	85 f6                	test   %esi,%esi
80103d7e:	74 76                	je     80103df6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d80:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103d86:	74 50                	je     80103dd8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d88:	83 ec 0c             	sub    $0xc,%esp
80103d8b:	68 20 2d 11 80       	push   $0x80112d20
80103d90:	e8 3b 05 00 00       	call   801042d0 <acquire>
    release(lk);
80103d95:	89 34 24             	mov    %esi,(%esp)
80103d98:	e8 53 06 00 00       	call   801043f0 <release>
  p->chan = chan;
80103d9d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103da0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103da7:	e8 64 fd ff ff       	call   80103b10 <sched>
  p->chan = 0;
80103dac:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103db3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103dba:	e8 31 06 00 00       	call   801043f0 <release>
    acquire(lk);
80103dbf:	89 75 08             	mov    %esi,0x8(%ebp)
80103dc2:	83 c4 10             	add    $0x10,%esp
}
80103dc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dc8:	5b                   	pop    %ebx
80103dc9:	5e                   	pop    %esi
80103dca:	5f                   	pop    %edi
80103dcb:	5d                   	pop    %ebp
    acquire(lk);
80103dcc:	e9 ff 04 00 00       	jmp    801042d0 <acquire>
80103dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103dd8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103ddb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103de2:	e8 29 fd ff ff       	call   80103b10 <sched>
  p->chan = 0;
80103de7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103dee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103df1:	5b                   	pop    %ebx
80103df2:	5e                   	pop    %esi
80103df3:	5f                   	pop    %edi
80103df4:	5d                   	pop    %ebp
80103df5:	c3                   	ret    
    panic("sleep without lk");
80103df6:	83 ec 0c             	sub    $0xc,%esp
80103df9:	68 2f 75 10 80       	push   $0x8010752f
80103dfe:	e8 6d c5 ff ff       	call   80100370 <panic>
    panic("sleep");
80103e03:	83 ec 0c             	sub    $0xc,%esp
80103e06:	68 29 75 10 80       	push   $0x80107529
80103e0b:	e8 60 c5 ff ff       	call   80100370 <panic>

80103e10 <wait>:
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	56                   	push   %esi
80103e14:	53                   	push   %ebx
  pushcli();
80103e15:	e8 76 04 00 00       	call   80104290 <pushcli>
  c = mycpu();
80103e1a:	e8 d1 f8 ff ff       	call   801036f0 <mycpu>
  p = c->proc;
80103e1f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e25:	e8 56 05 00 00       	call   80104380 <popcli>
  acquire(&ptable.lock);
80103e2a:	83 ec 0c             	sub    $0xc,%esp
80103e2d:	68 20 2d 11 80       	push   $0x80112d20
80103e32:	e8 99 04 00 00       	call   801042d0 <acquire>
80103e37:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103e3a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e3c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103e41:	eb 10                	jmp    80103e53 <wait+0x43>
80103e43:	90                   	nop
80103e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e48:	83 c3 7c             	add    $0x7c,%ebx
80103e4b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103e51:	73 1d                	jae    80103e70 <wait+0x60>
      if(p->parent != curproc)
80103e53:	39 73 14             	cmp    %esi,0x14(%ebx)
80103e56:	75 f0                	jne    80103e48 <wait+0x38>
      if(p->state == ZOMBIE){
80103e58:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103e5c:	74 30                	je     80103e8e <wait+0x7e>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e5e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103e61:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e66:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103e6c:	72 e5                	jb     80103e53 <wait+0x43>
80103e6e:	66 90                	xchg   %ax,%ax
    if(!havekids || curproc->killed){
80103e70:	85 c0                	test   %eax,%eax
80103e72:	74 70                	je     80103ee4 <wait+0xd4>
80103e74:	8b 46 24             	mov    0x24(%esi),%eax
80103e77:	85 c0                	test   %eax,%eax
80103e79:	75 69                	jne    80103ee4 <wait+0xd4>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103e7b:	83 ec 08             	sub    $0x8,%esp
80103e7e:	68 20 2d 11 80       	push   $0x80112d20
80103e83:	56                   	push   %esi
80103e84:	e8 c7 fe ff ff       	call   80103d50 <sleep>
    havekids = 0;
80103e89:	83 c4 10             	add    $0x10,%esp
80103e8c:	eb ac                	jmp    80103e3a <wait+0x2a>
        kfree(p->kstack);
80103e8e:	83 ec 0c             	sub    $0xc,%esp
80103e91:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103e94:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103e97:	e8 44 e4 ff ff       	call   801022e0 <kfree>
        freevm(p->pgdir);
80103e9c:	5a                   	pop    %edx
80103e9d:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103ea0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103ea7:	e8 74 2d 00 00       	call   80106c20 <freevm>
        p->pid = 0;
80103eac:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103eb3:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103eba:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103ebe:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103ec5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103ecc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ed3:	e8 18 05 00 00       	call   801043f0 <release>
        return pid;
80103ed8:	83 c4 10             	add    $0x10,%esp
}
80103edb:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ede:	89 f0                	mov    %esi,%eax
80103ee0:	5b                   	pop    %ebx
80103ee1:	5e                   	pop    %esi
80103ee2:	5d                   	pop    %ebp
80103ee3:	c3                   	ret    
      release(&ptable.lock);
80103ee4:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103ee7:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103eec:	68 20 2d 11 80       	push   $0x80112d20
80103ef1:	e8 fa 04 00 00       	call   801043f0 <release>
      return -1;
80103ef6:	83 c4 10             	add    $0x10,%esp
}
80103ef9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103efc:	89 f0                	mov    %esi,%eax
80103efe:	5b                   	pop    %ebx
80103eff:	5e                   	pop    %esi
80103f00:	5d                   	pop    %ebp
80103f01:	c3                   	ret    
80103f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f10 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	53                   	push   %ebx
80103f14:	83 ec 10             	sub    $0x10,%esp
80103f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103f1a:	68 20 2d 11 80       	push   $0x80112d20
80103f1f:	e8 ac 03 00 00       	call   801042d0 <acquire>
80103f24:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f27:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f2c:	eb 0c                	jmp    80103f3a <wakeup+0x2a>
80103f2e:	66 90                	xchg   %ax,%ax
80103f30:	83 c0 7c             	add    $0x7c,%eax
80103f33:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103f38:	73 1c                	jae    80103f56 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80103f3a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f3e:	75 f0                	jne    80103f30 <wakeup+0x20>
80103f40:	3b 58 20             	cmp    0x20(%eax),%ebx
80103f43:	75 eb                	jne    80103f30 <wakeup+0x20>
      p->state = RUNNABLE;
80103f45:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f4c:	83 c0 7c             	add    $0x7c,%eax
80103f4f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103f54:	72 e4                	jb     80103f3a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80103f56:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103f5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f60:	c9                   	leave  
  release(&ptable.lock);
80103f61:	e9 8a 04 00 00       	jmp    801043f0 <release>
80103f66:	8d 76 00             	lea    0x0(%esi),%esi
80103f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f70 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	53                   	push   %ebx
80103f74:	83 ec 10             	sub    $0x10,%esp
80103f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103f7a:	68 20 2d 11 80       	push   $0x80112d20
80103f7f:	e8 4c 03 00 00       	call   801042d0 <acquire>
80103f84:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f87:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f8c:	eb 0c                	jmp    80103f9a <kill+0x2a>
80103f8e:	66 90                	xchg   %ax,%ax
80103f90:	83 c0 7c             	add    $0x7c,%eax
80103f93:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103f98:	73 3e                	jae    80103fd8 <kill+0x68>
    if(p->pid == pid){
80103f9a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103f9d:	75 f1                	jne    80103f90 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f9f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103fa3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103faa:	74 1c                	je     80103fc8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103fac:	83 ec 0c             	sub    $0xc,%esp
80103faf:	68 20 2d 11 80       	push   $0x80112d20
80103fb4:	e8 37 04 00 00       	call   801043f0 <release>
      return 0;
80103fb9:	83 c4 10             	add    $0x10,%esp
80103fbc:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103fbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fc1:	c9                   	leave  
80103fc2:	c3                   	ret    
80103fc3:	90                   	nop
80103fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->state = RUNNABLE;
80103fc8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fcf:	eb db                	jmp    80103fac <kill+0x3c>
80103fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103fd8:	83 ec 0c             	sub    $0xc,%esp
80103fdb:	68 20 2d 11 80       	push   $0x80112d20
80103fe0:	e8 0b 04 00 00       	call   801043f0 <release>
  return -1;
80103fe5:	83 c4 10             	add    $0x10,%esp
80103fe8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103fed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ff0:	c9                   	leave  
80103ff1:	c3                   	ret    
80103ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104000 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	57                   	push   %edi
80104004:	56                   	push   %esi
80104005:	53                   	push   %ebx
80104006:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104009:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
8010400e:	83 ec 3c             	sub    $0x3c,%esp
80104011:	eb 24                	jmp    80104037 <procdump+0x37>
80104013:	90                   	nop
80104014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104018:	83 ec 0c             	sub    $0xc,%esp
8010401b:	68 bb 78 10 80       	push   $0x801078bb
80104020:	e8 3b c6 ff ff       	call   80100660 <cprintf>
80104025:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104028:	83 c3 7c             	add    $0x7c,%ebx
8010402b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80104031:	0f 83 81 00 00 00    	jae    801040b8 <procdump+0xb8>
    if(p->state == UNUSED)
80104037:	8b 43 0c             	mov    0xc(%ebx),%eax
8010403a:	85 c0                	test   %eax,%eax
8010403c:	74 ea                	je     80104028 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010403e:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104041:	ba 40 75 10 80       	mov    $0x80107540,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104046:	77 11                	ja     80104059 <procdump+0x59>
80104048:	8b 14 85 a0 75 10 80 	mov    -0x7fef8a60(,%eax,4),%edx
      state = "???";
8010404f:	b8 40 75 10 80       	mov    $0x80107540,%eax
80104054:	85 d2                	test   %edx,%edx
80104056:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104059:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010405c:	50                   	push   %eax
8010405d:	52                   	push   %edx
8010405e:	ff 73 10             	pushl  0x10(%ebx)
80104061:	68 44 75 10 80       	push   $0x80107544
80104066:	e8 f5 c5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010406b:	83 c4 10             	add    $0x10,%esp
8010406e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104072:	75 a4                	jne    80104018 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104074:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104077:	83 ec 08             	sub    $0x8,%esp
8010407a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010407d:	50                   	push   %eax
8010407e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104081:	8b 40 0c             	mov    0xc(%eax),%eax
80104084:	83 c0 08             	add    $0x8,%eax
80104087:	50                   	push   %eax
80104088:	e8 63 01 00 00       	call   801041f0 <getcallerpcs>
8010408d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104090:	8b 17                	mov    (%edi),%edx
80104092:	85 d2                	test   %edx,%edx
80104094:	74 82                	je     80104018 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104096:	83 ec 08             	sub    $0x8,%esp
80104099:	83 c7 04             	add    $0x4,%edi
8010409c:	52                   	push   %edx
8010409d:	68 81 6f 10 80       	push   $0x80106f81
801040a2:	e8 b9 c5 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801040a7:	83 c4 10             	add    $0x10,%esp
801040aa:	39 fe                	cmp    %edi,%esi
801040ac:	75 e2                	jne    80104090 <procdump+0x90>
801040ae:	e9 65 ff ff ff       	jmp    80104018 <procdump+0x18>
801040b3:	90                   	nop
801040b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
801040b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040bb:	5b                   	pop    %ebx
801040bc:	5e                   	pop    %esi
801040bd:	5f                   	pop    %edi
801040be:	5d                   	pop    %ebp
801040bf:	c3                   	ret    

801040c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	53                   	push   %ebx
801040c4:	83 ec 0c             	sub    $0xc,%esp
801040c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801040ca:	68 b8 75 10 80       	push   $0x801075b8
801040cf:	8d 43 04             	lea    0x4(%ebx),%eax
801040d2:	50                   	push   %eax
801040d3:	e8 f8 00 00 00       	call   801041d0 <initlock>
  lk->name = name;
801040d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801040db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801040e1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801040e4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801040eb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801040ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040f1:	c9                   	leave  
801040f2:	c3                   	ret    
801040f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801040f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104100 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	56                   	push   %esi
80104104:	53                   	push   %ebx
80104105:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104108:	83 ec 0c             	sub    $0xc,%esp
8010410b:	8d 73 04             	lea    0x4(%ebx),%esi
8010410e:	56                   	push   %esi
8010410f:	e8 bc 01 00 00       	call   801042d0 <acquire>
  while (lk->locked) {
80104114:	8b 13                	mov    (%ebx),%edx
80104116:	83 c4 10             	add    $0x10,%esp
80104119:	85 d2                	test   %edx,%edx
8010411b:	74 16                	je     80104133 <acquiresleep+0x33>
8010411d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104120:	83 ec 08             	sub    $0x8,%esp
80104123:	56                   	push   %esi
80104124:	53                   	push   %ebx
80104125:	e8 26 fc ff ff       	call   80103d50 <sleep>
  while (lk->locked) {
8010412a:	8b 03                	mov    (%ebx),%eax
8010412c:	83 c4 10             	add    $0x10,%esp
8010412f:	85 c0                	test   %eax,%eax
80104131:	75 ed                	jne    80104120 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104133:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104139:	e8 52 f6 ff ff       	call   80103790 <myproc>
8010413e:	8b 40 10             	mov    0x10(%eax),%eax
80104141:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104144:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104147:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010414a:	5b                   	pop    %ebx
8010414b:	5e                   	pop    %esi
8010414c:	5d                   	pop    %ebp
  release(&lk->lk);
8010414d:	e9 9e 02 00 00       	jmp    801043f0 <release>
80104152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104160 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	56                   	push   %esi
80104164:	53                   	push   %ebx
80104165:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104168:	83 ec 0c             	sub    $0xc,%esp
8010416b:	8d 73 04             	lea    0x4(%ebx),%esi
8010416e:	56                   	push   %esi
8010416f:	e8 5c 01 00 00       	call   801042d0 <acquire>
  lk->locked = 0;
80104174:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010417a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104181:	89 1c 24             	mov    %ebx,(%esp)
80104184:	e8 87 fd ff ff       	call   80103f10 <wakeup>
  release(&lk->lk);
80104189:	89 75 08             	mov    %esi,0x8(%ebp)
8010418c:	83 c4 10             	add    $0x10,%esp
}
8010418f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104192:	5b                   	pop    %ebx
80104193:	5e                   	pop    %esi
80104194:	5d                   	pop    %ebp
  release(&lk->lk);
80104195:	e9 56 02 00 00       	jmp    801043f0 <release>
8010419a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	56                   	push   %esi
801041a4:	53                   	push   %ebx
801041a5:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801041a8:	83 ec 0c             	sub    $0xc,%esp
801041ab:	8d 5e 04             	lea    0x4(%esi),%ebx
801041ae:	53                   	push   %ebx
801041af:	e8 1c 01 00 00       	call   801042d0 <acquire>
  r = lk->locked;
801041b4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801041b6:	89 1c 24             	mov    %ebx,(%esp)
801041b9:	e8 32 02 00 00       	call   801043f0 <release>
  return r;
}
801041be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041c1:	89 f0                	mov    %esi,%eax
801041c3:	5b                   	pop    %ebx
801041c4:	5e                   	pop    %esi
801041c5:	5d                   	pop    %ebp
801041c6:	c3                   	ret    
801041c7:	66 90                	xchg   %ax,%ax
801041c9:	66 90                	xchg   %ax,%ax
801041cb:	66 90                	xchg   %ax,%ax
801041cd:	66 90                	xchg   %ax,%ax
801041cf:	90                   	nop

801041d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801041d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801041d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801041df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801041e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801041e9:	5d                   	pop    %ebp
801041ea:	c3                   	ret    
801041eb:	90                   	nop
801041ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801041f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801041f4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801041f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801041fa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801041fd:	31 c0                	xor    %eax,%eax
801041ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104200:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104206:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010420c:	77 1a                	ja     80104228 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010420e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104211:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104214:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104217:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104219:	83 f8 0a             	cmp    $0xa,%eax
8010421c:	75 e2                	jne    80104200 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010421e:	5b                   	pop    %ebx
8010421f:	5d                   	pop    %ebp
80104220:	c3                   	ret    
80104221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104228:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
8010422f:	83 c0 01             	add    $0x1,%eax
80104232:	83 f8 0a             	cmp    $0xa,%eax
80104235:	74 e7                	je     8010421e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104237:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
8010423e:	83 c0 01             	add    $0x1,%eax
80104241:	83 f8 0a             	cmp    $0xa,%eax
80104244:	75 e2                	jne    80104228 <getcallerpcs+0x38>
80104246:	eb d6                	jmp    8010421e <getcallerpcs+0x2e>
80104248:	90                   	nop
80104249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104250 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	53                   	push   %ebx
80104254:	83 ec 04             	sub    $0x4,%esp
80104257:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010425a:	8b 02                	mov    (%edx),%eax
8010425c:	85 c0                	test   %eax,%eax
8010425e:	75 10                	jne    80104270 <holding+0x20>
}
80104260:	83 c4 04             	add    $0x4,%esp
80104263:	31 c0                	xor    %eax,%eax
80104265:	5b                   	pop    %ebx
80104266:	5d                   	pop    %ebp
80104267:	c3                   	ret    
80104268:	90                   	nop
80104269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104270:	8b 5a 08             	mov    0x8(%edx),%ebx
80104273:	e8 78 f4 ff ff       	call   801036f0 <mycpu>
80104278:	39 c3                	cmp    %eax,%ebx
8010427a:	0f 94 c0             	sete   %al
}
8010427d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104280:	0f b6 c0             	movzbl %al,%eax
}
80104283:	5b                   	pop    %ebx
80104284:	5d                   	pop    %ebp
80104285:	c3                   	ret    
80104286:	8d 76 00             	lea    0x0(%esi),%esi
80104289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104290 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	53                   	push   %ebx
80104294:	83 ec 04             	sub    $0x4,%esp
80104297:	9c                   	pushf  
80104298:	5b                   	pop    %ebx
  asm volatile("cli");
80104299:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010429a:	e8 51 f4 ff ff       	call   801036f0 <mycpu>
8010429f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801042a5:	85 c0                	test   %eax,%eax
801042a7:	75 11                	jne    801042ba <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801042a9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801042af:	e8 3c f4 ff ff       	call   801036f0 <mycpu>
801042b4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801042ba:	e8 31 f4 ff ff       	call   801036f0 <mycpu>
801042bf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801042c6:	83 c4 04             	add    $0x4,%esp
801042c9:	5b                   	pop    %ebx
801042ca:	5d                   	pop    %ebp
801042cb:	c3                   	ret    
801042cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042d0 <acquire>:
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	56                   	push   %esi
801042d4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801042d5:	e8 b6 ff ff ff       	call   80104290 <pushcli>
  if(holding(lk))
801042da:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801042dd:	8b 03                	mov    (%ebx),%eax
801042df:	85 c0                	test   %eax,%eax
801042e1:	75 7d                	jne    80104360 <acquire+0x90>
  asm volatile("lock; xchgl %0, %1" :
801042e3:	ba 01 00 00 00       	mov    $0x1,%edx
801042e8:	eb 09                	jmp    801042f3 <acquire+0x23>
801042ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801042f3:	89 d0                	mov    %edx,%eax
801042f5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801042f8:	85 c0                	test   %eax,%eax
801042fa:	75 f4                	jne    801042f0 <acquire+0x20>
  __sync_synchronize();
801042fc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104301:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104304:	e8 e7 f3 ff ff       	call   801036f0 <mycpu>
  ebp = (uint*)v - 2;
80104309:	89 ea                	mov    %ebp,%edx
  getcallerpcs(&lk, lk->pcs);
8010430b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
8010430e:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104311:	31 c0                	xor    %eax,%eax
80104313:	90                   	nop
80104314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104318:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
8010431e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104324:	77 1a                	ja     80104340 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
80104326:	8b 5a 04             	mov    0x4(%edx),%ebx
80104329:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
8010432c:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
8010432f:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104331:	83 f8 0a             	cmp    $0xa,%eax
80104334:	75 e2                	jne    80104318 <acquire+0x48>
}
80104336:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104339:	5b                   	pop    %ebx
8010433a:	5e                   	pop    %esi
8010433b:	5d                   	pop    %ebp
8010433c:	c3                   	ret    
8010433d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104340:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80104347:	83 c0 01             	add    $0x1,%eax
8010434a:	83 f8 0a             	cmp    $0xa,%eax
8010434d:	74 e7                	je     80104336 <acquire+0x66>
    pcs[i] = 0;
8010434f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80104356:	83 c0 01             	add    $0x1,%eax
80104359:	83 f8 0a             	cmp    $0xa,%eax
8010435c:	75 e2                	jne    80104340 <acquire+0x70>
8010435e:	eb d6                	jmp    80104336 <acquire+0x66>
  return lock->locked && lock->cpu == mycpu();
80104360:	8b 73 08             	mov    0x8(%ebx),%esi
80104363:	e8 88 f3 ff ff       	call   801036f0 <mycpu>
80104368:	39 c6                	cmp    %eax,%esi
8010436a:	0f 85 73 ff ff ff    	jne    801042e3 <acquire+0x13>
    panic("acquire");
80104370:	83 ec 0c             	sub    $0xc,%esp
80104373:	68 c3 75 10 80       	push   $0x801075c3
80104378:	e8 f3 bf ff ff       	call   80100370 <panic>
8010437d:	8d 76 00             	lea    0x0(%esi),%esi

80104380 <popcli>:

void
popcli(void)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104386:	9c                   	pushf  
80104387:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104388:	f6 c4 02             	test   $0x2,%ah
8010438b:	75 52                	jne    801043df <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010438d:	e8 5e f3 ff ff       	call   801036f0 <mycpu>
80104392:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104398:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010439b:	85 d2                	test   %edx,%edx
8010439d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801043a3:	78 2d                	js     801043d2 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801043a5:	e8 46 f3 ff ff       	call   801036f0 <mycpu>
801043aa:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801043b0:	85 d2                	test   %edx,%edx
801043b2:	74 0c                	je     801043c0 <popcli+0x40>
    sti();
}
801043b4:	c9                   	leave  
801043b5:	c3                   	ret    
801043b6:	8d 76 00             	lea    0x0(%esi),%esi
801043b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801043c0:	e8 2b f3 ff ff       	call   801036f0 <mycpu>
801043c5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801043cb:	85 c0                	test   %eax,%eax
801043cd:	74 e5                	je     801043b4 <popcli+0x34>
  asm volatile("sti");
801043cf:	fb                   	sti    
}
801043d0:	c9                   	leave  
801043d1:	c3                   	ret    
    panic("popcli");
801043d2:	83 ec 0c             	sub    $0xc,%esp
801043d5:	68 e2 75 10 80       	push   $0x801075e2
801043da:	e8 91 bf ff ff       	call   80100370 <panic>
    panic("popcli - interruptible");
801043df:	83 ec 0c             	sub    $0xc,%esp
801043e2:	68 cb 75 10 80       	push   $0x801075cb
801043e7:	e8 84 bf ff ff       	call   80100370 <panic>
801043ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801043f0 <release>:
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	56                   	push   %esi
801043f4:	53                   	push   %ebx
801043f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801043f8:	8b 03                	mov    (%ebx),%eax
801043fa:	85 c0                	test   %eax,%eax
801043fc:	75 12                	jne    80104410 <release+0x20>
    panic("release");
801043fe:	83 ec 0c             	sub    $0xc,%esp
80104401:	68 e9 75 10 80       	push   $0x801075e9
80104406:	e8 65 bf ff ff       	call   80100370 <panic>
8010440b:	90                   	nop
8010440c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104410:	8b 73 08             	mov    0x8(%ebx),%esi
80104413:	e8 d8 f2 ff ff       	call   801036f0 <mycpu>
80104418:	39 c6                	cmp    %eax,%esi
8010441a:	75 e2                	jne    801043fe <release+0xe>
  lk->pcs[0] = 0;
8010441c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104423:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010442a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010442f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104435:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104438:	5b                   	pop    %ebx
80104439:	5e                   	pop    %esi
8010443a:	5d                   	pop    %ebp
  popcli();
8010443b:	e9 40 ff ff ff       	jmp    80104380 <popcli>

80104440 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	57                   	push   %edi
80104444:	53                   	push   %ebx
80104445:	8b 55 08             	mov    0x8(%ebp),%edx
80104448:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010444b:	f6 c2 03             	test   $0x3,%dl
8010444e:	75 05                	jne    80104455 <memset+0x15>
80104450:	f6 c1 03             	test   $0x3,%cl
80104453:	74 13                	je     80104468 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104455:	89 d7                	mov    %edx,%edi
80104457:	8b 45 0c             	mov    0xc(%ebp),%eax
8010445a:	fc                   	cld    
8010445b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010445d:	5b                   	pop    %ebx
8010445e:	89 d0                	mov    %edx,%eax
80104460:	5f                   	pop    %edi
80104461:	5d                   	pop    %ebp
80104462:	c3                   	ret    
80104463:	90                   	nop
80104464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104468:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010446c:	c1 e9 02             	shr    $0x2,%ecx
8010446f:	89 f8                	mov    %edi,%eax
80104471:	89 fb                	mov    %edi,%ebx
80104473:	c1 e0 18             	shl    $0x18,%eax
80104476:	c1 e3 10             	shl    $0x10,%ebx
80104479:	09 d8                	or     %ebx,%eax
8010447b:	09 f8                	or     %edi,%eax
8010447d:	c1 e7 08             	shl    $0x8,%edi
80104480:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104482:	89 d7                	mov    %edx,%edi
80104484:	fc                   	cld    
80104485:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104487:	5b                   	pop    %ebx
80104488:	89 d0                	mov    %edx,%eax
8010448a:	5f                   	pop    %edi
8010448b:	5d                   	pop    %ebp
8010448c:	c3                   	ret    
8010448d:	8d 76 00             	lea    0x0(%esi),%esi

80104490 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	57                   	push   %edi
80104494:	56                   	push   %esi
80104495:	53                   	push   %ebx
80104496:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104499:	8b 75 08             	mov    0x8(%ebp),%esi
8010449c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010449f:	85 db                	test   %ebx,%ebx
801044a1:	74 29                	je     801044cc <memcmp+0x3c>
    if(*s1 != *s2)
801044a3:	0f b6 16             	movzbl (%esi),%edx
801044a6:	0f b6 0f             	movzbl (%edi),%ecx
801044a9:	38 d1                	cmp    %dl,%cl
801044ab:	75 2b                	jne    801044d8 <memcmp+0x48>
801044ad:	b8 01 00 00 00       	mov    $0x1,%eax
801044b2:	eb 14                	jmp    801044c8 <memcmp+0x38>
801044b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044b8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801044bc:	83 c0 01             	add    $0x1,%eax
801044bf:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801044c4:	38 ca                	cmp    %cl,%dl
801044c6:	75 10                	jne    801044d8 <memcmp+0x48>
  while(n-- > 0){
801044c8:	39 d8                	cmp    %ebx,%eax
801044ca:	75 ec                	jne    801044b8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801044cc:	5b                   	pop    %ebx
  return 0;
801044cd:	31 c0                	xor    %eax,%eax
}
801044cf:	5e                   	pop    %esi
801044d0:	5f                   	pop    %edi
801044d1:	5d                   	pop    %ebp
801044d2:	c3                   	ret    
801044d3:	90                   	nop
801044d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801044d8:	0f b6 c2             	movzbl %dl,%eax
}
801044db:	5b                   	pop    %ebx
      return *s1 - *s2;
801044dc:	29 c8                	sub    %ecx,%eax
}
801044de:	5e                   	pop    %esi
801044df:	5f                   	pop    %edi
801044e0:	5d                   	pop    %ebp
801044e1:	c3                   	ret    
801044e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	56                   	push   %esi
801044f4:	53                   	push   %ebx
801044f5:	8b 45 08             	mov    0x8(%ebp),%eax
801044f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801044fb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801044fe:	39 c3                	cmp    %eax,%ebx
80104500:	73 26                	jae    80104528 <memmove+0x38>
80104502:	8d 14 33             	lea    (%ebx,%esi,1),%edx
80104505:	39 d0                	cmp    %edx,%eax
80104507:	73 1f                	jae    80104528 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104509:	85 f6                	test   %esi,%esi
8010450b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010450e:	74 0f                	je     8010451f <memmove+0x2f>
      *--d = *--s;
80104510:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104514:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104517:	83 ea 01             	sub    $0x1,%edx
8010451a:	83 fa ff             	cmp    $0xffffffff,%edx
8010451d:	75 f1                	jne    80104510 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010451f:	5b                   	pop    %ebx
80104520:	5e                   	pop    %esi
80104521:	5d                   	pop    %ebp
80104522:	c3                   	ret    
80104523:	90                   	nop
80104524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104528:	31 d2                	xor    %edx,%edx
8010452a:	85 f6                	test   %esi,%esi
8010452c:	74 f1                	je     8010451f <memmove+0x2f>
8010452e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104530:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104534:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104537:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010453a:	39 f2                	cmp    %esi,%edx
8010453c:	75 f2                	jne    80104530 <memmove+0x40>
}
8010453e:	5b                   	pop    %ebx
8010453f:	5e                   	pop    %esi
80104540:	5d                   	pop    %ebp
80104541:	c3                   	ret    
80104542:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104550 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104553:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104554:	eb 9a                	jmp    801044f0 <memmove>
80104556:	8d 76 00             	lea    0x0(%esi),%esi
80104559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104560 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	57                   	push   %edi
80104564:	56                   	push   %esi
80104565:	8b 7d 10             	mov    0x10(%ebp),%edi
80104568:	53                   	push   %ebx
80104569:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010456c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010456f:	85 ff                	test   %edi,%edi
80104571:	74 2f                	je     801045a2 <strncmp+0x42>
80104573:	0f b6 11             	movzbl (%ecx),%edx
80104576:	0f b6 1e             	movzbl (%esi),%ebx
80104579:	84 d2                	test   %dl,%dl
8010457b:	74 37                	je     801045b4 <strncmp+0x54>
8010457d:	38 d3                	cmp    %dl,%bl
8010457f:	75 33                	jne    801045b4 <strncmp+0x54>
80104581:	01 f7                	add    %esi,%edi
80104583:	eb 13                	jmp    80104598 <strncmp+0x38>
80104585:	8d 76 00             	lea    0x0(%esi),%esi
80104588:	0f b6 11             	movzbl (%ecx),%edx
8010458b:	84 d2                	test   %dl,%dl
8010458d:	74 21                	je     801045b0 <strncmp+0x50>
8010458f:	0f b6 18             	movzbl (%eax),%ebx
80104592:	89 c6                	mov    %eax,%esi
80104594:	38 da                	cmp    %bl,%dl
80104596:	75 1c                	jne    801045b4 <strncmp+0x54>
    n--, p++, q++;
80104598:	8d 46 01             	lea    0x1(%esi),%eax
8010459b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010459e:	39 f8                	cmp    %edi,%eax
801045a0:	75 e6                	jne    80104588 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801045a2:	5b                   	pop    %ebx
    return 0;
801045a3:	31 c0                	xor    %eax,%eax
}
801045a5:	5e                   	pop    %esi
801045a6:	5f                   	pop    %edi
801045a7:	5d                   	pop    %ebp
801045a8:	c3                   	ret    
801045a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045b0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801045b4:	0f b6 c2             	movzbl %dl,%eax
801045b7:	29 d8                	sub    %ebx,%eax
}
801045b9:	5b                   	pop    %ebx
801045ba:	5e                   	pop    %esi
801045bb:	5f                   	pop    %edi
801045bc:	5d                   	pop    %ebp
801045bd:	c3                   	ret    
801045be:	66 90                	xchg   %ax,%ax

801045c0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	56                   	push   %esi
801045c4:	53                   	push   %ebx
801045c5:	8b 45 08             	mov    0x8(%ebp),%eax
801045c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801045cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801045ce:	89 c2                	mov    %eax,%edx
801045d0:	eb 19                	jmp    801045eb <strncpy+0x2b>
801045d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045d8:	83 c3 01             	add    $0x1,%ebx
801045db:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801045df:	83 c2 01             	add    $0x1,%edx
801045e2:	84 c9                	test   %cl,%cl
801045e4:	88 4a ff             	mov    %cl,-0x1(%edx)
801045e7:	74 09                	je     801045f2 <strncpy+0x32>
801045e9:	89 f1                	mov    %esi,%ecx
801045eb:	85 c9                	test   %ecx,%ecx
801045ed:	8d 71 ff             	lea    -0x1(%ecx),%esi
801045f0:	7f e6                	jg     801045d8 <strncpy+0x18>
    ;
  while(n-- > 0)
801045f2:	31 c9                	xor    %ecx,%ecx
801045f4:	85 f6                	test   %esi,%esi
801045f6:	7e 17                	jle    8010460f <strncpy+0x4f>
801045f8:	90                   	nop
801045f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104600:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104604:	89 f3                	mov    %esi,%ebx
80104606:	83 c1 01             	add    $0x1,%ecx
80104609:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010460b:	85 db                	test   %ebx,%ebx
8010460d:	7f f1                	jg     80104600 <strncpy+0x40>
  return os;
}
8010460f:	5b                   	pop    %ebx
80104610:	5e                   	pop    %esi
80104611:	5d                   	pop    %ebp
80104612:	c3                   	ret    
80104613:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104620 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	56                   	push   %esi
80104624:	53                   	push   %ebx
80104625:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104628:	8b 45 08             	mov    0x8(%ebp),%eax
8010462b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010462e:	85 c9                	test   %ecx,%ecx
80104630:	7e 26                	jle    80104658 <safestrcpy+0x38>
80104632:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104636:	89 c1                	mov    %eax,%ecx
80104638:	eb 17                	jmp    80104651 <safestrcpy+0x31>
8010463a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104640:	83 c2 01             	add    $0x1,%edx
80104643:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104647:	83 c1 01             	add    $0x1,%ecx
8010464a:	84 db                	test   %bl,%bl
8010464c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010464f:	74 04                	je     80104655 <safestrcpy+0x35>
80104651:	39 f2                	cmp    %esi,%edx
80104653:	75 eb                	jne    80104640 <safestrcpy+0x20>
    ;
  *s = 0;
80104655:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104658:	5b                   	pop    %ebx
80104659:	5e                   	pop    %esi
8010465a:	5d                   	pop    %ebp
8010465b:	c3                   	ret    
8010465c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104660 <strlen>:

int
strlen(const char *s)
{
80104660:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104661:	31 c0                	xor    %eax,%eax
{
80104663:	89 e5                	mov    %esp,%ebp
80104665:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104668:	80 3a 00             	cmpb   $0x0,(%edx)
8010466b:	74 0c                	je     80104679 <strlen+0x19>
8010466d:	8d 76 00             	lea    0x0(%esi),%esi
80104670:	83 c0 01             	add    $0x1,%eax
80104673:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104677:	75 f7                	jne    80104670 <strlen+0x10>
    ;
  return n;
}
80104679:	5d                   	pop    %ebp
8010467a:	c3                   	ret    

8010467b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010467b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010467f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104683:	55                   	push   %ebp
  pushl %ebx
80104684:	53                   	push   %ebx
  pushl %esi
80104685:	56                   	push   %esi
  pushl %edi
80104686:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104687:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104689:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010468b:	5f                   	pop    %edi
  popl %esi
8010468c:	5e                   	pop    %esi
  popl %ebx
8010468d:	5b                   	pop    %ebx
  popl %ebp
8010468e:	5d                   	pop    %ebp
  ret
8010468f:	c3                   	ret    

80104690 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	53                   	push   %ebx
80104694:	83 ec 04             	sub    $0x4,%esp
80104697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010469a:	e8 f1 f0 ff ff       	call   80103790 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010469f:	8b 00                	mov    (%eax),%eax
801046a1:	39 d8                	cmp    %ebx,%eax
801046a3:	76 1b                	jbe    801046c0 <fetchint+0x30>
801046a5:	8d 53 04             	lea    0x4(%ebx),%edx
801046a8:	39 d0                	cmp    %edx,%eax
801046aa:	72 14                	jb     801046c0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801046ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801046af:	8b 13                	mov    (%ebx),%edx
801046b1:	89 10                	mov    %edx,(%eax)
  return 0;
801046b3:	31 c0                	xor    %eax,%eax
}
801046b5:	83 c4 04             	add    $0x4,%esp
801046b8:	5b                   	pop    %ebx
801046b9:	5d                   	pop    %ebp
801046ba:	c3                   	ret    
801046bb:	90                   	nop
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801046c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046c5:	eb ee                	jmp    801046b5 <fetchint+0x25>
801046c7:	89 f6                	mov    %esi,%esi
801046c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046d0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	53                   	push   %ebx
801046d4:	83 ec 04             	sub    $0x4,%esp
801046d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801046da:	e8 b1 f0 ff ff       	call   80103790 <myproc>

  if(addr >= curproc->sz)
801046df:	39 18                	cmp    %ebx,(%eax)
801046e1:	76 29                	jbe    8010470c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801046e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801046e6:	89 da                	mov    %ebx,%edx
801046e8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801046ea:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801046ec:	39 c3                	cmp    %eax,%ebx
801046ee:	73 1c                	jae    8010470c <fetchstr+0x3c>
    if(*s == 0)
801046f0:	80 3b 00             	cmpb   $0x0,(%ebx)
801046f3:	75 10                	jne    80104705 <fetchstr+0x35>
801046f5:	eb 29                	jmp    80104720 <fetchstr+0x50>
801046f7:	89 f6                	mov    %esi,%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104700:	80 3a 00             	cmpb   $0x0,(%edx)
80104703:	74 1b                	je     80104720 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104705:	83 c2 01             	add    $0x1,%edx
80104708:	39 d0                	cmp    %edx,%eax
8010470a:	77 f4                	ja     80104700 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010470c:	83 c4 04             	add    $0x4,%esp
    return -1;
8010470f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104714:	5b                   	pop    %ebx
80104715:	5d                   	pop    %ebp
80104716:	c3                   	ret    
80104717:	89 f6                	mov    %esi,%esi
80104719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104720:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104723:	89 d0                	mov    %edx,%eax
80104725:	29 d8                	sub    %ebx,%eax
}
80104727:	5b                   	pop    %ebx
80104728:	5d                   	pop    %ebp
80104729:	c3                   	ret    
8010472a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104730 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	56                   	push   %esi
80104734:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104735:	e8 56 f0 ff ff       	call   80103790 <myproc>
8010473a:	8b 40 18             	mov    0x18(%eax),%eax
8010473d:	8b 55 08             	mov    0x8(%ebp),%edx
80104740:	8b 40 44             	mov    0x44(%eax),%eax
80104743:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104746:	e8 45 f0 ff ff       	call   80103790 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010474b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010474d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104750:	39 c6                	cmp    %eax,%esi
80104752:	73 1c                	jae    80104770 <argint+0x40>
80104754:	8d 53 08             	lea    0x8(%ebx),%edx
80104757:	39 d0                	cmp    %edx,%eax
80104759:	72 15                	jb     80104770 <argint+0x40>
  *ip = *(int*)(addr);
8010475b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010475e:	8b 53 04             	mov    0x4(%ebx),%edx
80104761:	89 10                	mov    %edx,(%eax)
  return 0;
80104763:	31 c0                	xor    %eax,%eax
}
80104765:	5b                   	pop    %ebx
80104766:	5e                   	pop    %esi
80104767:	5d                   	pop    %ebp
80104768:	c3                   	ret    
80104769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104775:	eb ee                	jmp    80104765 <argint+0x35>
80104777:	89 f6                	mov    %esi,%esi
80104779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104780 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	53                   	push   %ebx
80104785:	83 ec 10             	sub    $0x10,%esp
80104788:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010478b:	e8 00 f0 ff ff       	call   80103790 <myproc>
80104790:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104792:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104795:	83 ec 08             	sub    $0x8,%esp
80104798:	50                   	push   %eax
80104799:	ff 75 08             	pushl  0x8(%ebp)
8010479c:	e8 8f ff ff ff       	call   80104730 <argint>
801047a1:	c1 e8 1f             	shr    $0x1f,%eax
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801047a4:	83 c4 10             	add    $0x10,%esp
801047a7:	84 c0                	test   %al,%al
801047a9:	75 2d                	jne    801047d8 <argptr+0x58>
801047ab:	89 d8                	mov    %ebx,%eax
801047ad:	c1 e8 1f             	shr    $0x1f,%eax
801047b0:	84 c0                	test   %al,%al
801047b2:	75 24                	jne    801047d8 <argptr+0x58>
801047b4:	8b 16                	mov    (%esi),%edx
801047b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b9:	39 c2                	cmp    %eax,%edx
801047bb:	76 1b                	jbe    801047d8 <argptr+0x58>
801047bd:	01 c3                	add    %eax,%ebx
801047bf:	39 da                	cmp    %ebx,%edx
801047c1:	72 15                	jb     801047d8 <argptr+0x58>
    return -1;
  *pp = (char*)i;
801047c3:	8b 55 0c             	mov    0xc(%ebp),%edx
801047c6:	89 02                	mov    %eax,(%edx)
  return 0;
801047c8:	31 c0                	xor    %eax,%eax
}
801047ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047cd:	5b                   	pop    %ebx
801047ce:	5e                   	pop    %esi
801047cf:	5d                   	pop    %ebp
801047d0:	c3                   	ret    
801047d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801047d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047dd:	eb eb                	jmp    801047ca <argptr+0x4a>
801047df:	90                   	nop

801047e0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801047e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801047e9:	50                   	push   %eax
801047ea:	ff 75 08             	pushl  0x8(%ebp)
801047ed:	e8 3e ff ff ff       	call   80104730 <argint>
801047f2:	83 c4 10             	add    $0x10,%esp
801047f5:	85 c0                	test   %eax,%eax
801047f7:	78 17                	js     80104810 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801047f9:	83 ec 08             	sub    $0x8,%esp
801047fc:	ff 75 0c             	pushl  0xc(%ebp)
801047ff:	ff 75 f4             	pushl  -0xc(%ebp)
80104802:	e8 c9 fe ff ff       	call   801046d0 <fetchstr>
80104807:	83 c4 10             	add    $0x10,%esp
}
8010480a:	c9                   	leave  
8010480b:	c3                   	ret    
8010480c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104810:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104815:	c9                   	leave  
80104816:	c3                   	ret    
80104817:	89 f6                	mov    %esi,%esi
80104819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104820 <syscall>:
[SYS_shutdown2] sys_shutdown2,
};

void
syscall(void)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	56                   	push   %esi
80104824:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104825:	e8 66 ef ff ff       	call   80103790 <myproc>

  num = curproc->tf->eax;
8010482a:	8b 70 18             	mov    0x18(%eax),%esi
  struct proc *curproc = myproc();
8010482d:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
8010482f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104832:	8d 50 ff             	lea    -0x1(%eax),%edx
80104835:	83 fa 15             	cmp    $0x15,%edx
80104838:	77 1e                	ja     80104858 <syscall+0x38>
8010483a:	8b 14 85 20 76 10 80 	mov    -0x7fef89e0(,%eax,4),%edx
80104841:	85 d2                	test   %edx,%edx
80104843:	74 13                	je     80104858 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104845:	ff d2                	call   *%edx
80104847:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010484a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010484d:	5b                   	pop    %ebx
8010484e:	5e                   	pop    %esi
8010484f:	5d                   	pop    %ebp
80104850:	c3                   	ret    
80104851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104858:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104859:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010485c:	50                   	push   %eax
8010485d:	ff 73 10             	pushl  0x10(%ebx)
80104860:	68 f1 75 10 80       	push   $0x801075f1
80104865:	e8 f6 bd ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010486a:	8b 43 18             	mov    0x18(%ebx),%eax
8010486d:	83 c4 10             	add    $0x10,%esp
80104870:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104877:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010487a:	5b                   	pop    %ebx
8010487b:	5e                   	pop    %esi
8010487c:	5d                   	pop    %ebp
8010487d:	c3                   	ret    
8010487e:	66 90                	xchg   %ax,%ax

80104880 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	57                   	push   %edi
80104884:	56                   	push   %esi
80104885:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104886:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
80104889:	83 ec 44             	sub    $0x44,%esp
8010488c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010488f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104892:	53                   	push   %ebx
80104893:	50                   	push   %eax
{
80104894:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104897:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010489a:	e8 41 d6 ff ff       	call   80101ee0 <nameiparent>
8010489f:	83 c4 10             	add    $0x10,%esp
801048a2:	85 c0                	test   %eax,%eax
801048a4:	0f 84 f6 00 00 00    	je     801049a0 <create+0x120>
    return 0;
  ilock(dp);
801048aa:	83 ec 0c             	sub    $0xc,%esp
801048ad:	89 c6                	mov    %eax,%esi
801048af:	50                   	push   %eax
801048b0:	e8 bb cd ff ff       	call   80101670 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801048b5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801048b8:	83 c4 0c             	add    $0xc,%esp
801048bb:	50                   	push   %eax
801048bc:	53                   	push   %ebx
801048bd:	56                   	push   %esi
801048be:	e8 dd d2 ff ff       	call   80101ba0 <dirlookup>
801048c3:	83 c4 10             	add    $0x10,%esp
801048c6:	85 c0                	test   %eax,%eax
801048c8:	89 c7                	mov    %eax,%edi
801048ca:	74 54                	je     80104920 <create+0xa0>
    iunlockput(dp);
801048cc:	83 ec 0c             	sub    $0xc,%esp
801048cf:	56                   	push   %esi
801048d0:	e8 2b d0 ff ff       	call   80101900 <iunlockput>
    ilock(ip);
801048d5:	89 3c 24             	mov    %edi,(%esp)
801048d8:	e8 93 cd ff ff       	call   80101670 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801048dd:	83 c4 10             	add    $0x10,%esp
801048e0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801048e5:	75 19                	jne    80104900 <create+0x80>
801048e7:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801048ec:	75 12                	jne    80104900 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801048ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048f1:	89 f8                	mov    %edi,%eax
801048f3:	5b                   	pop    %ebx
801048f4:	5e                   	pop    %esi
801048f5:	5f                   	pop    %edi
801048f6:	5d                   	pop    %ebp
801048f7:	c3                   	ret    
801048f8:	90                   	nop
801048f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80104900:	83 ec 0c             	sub    $0xc,%esp
80104903:	57                   	push   %edi
    return 0;
80104904:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104906:	e8 f5 cf ff ff       	call   80101900 <iunlockput>
    return 0;
8010490b:	83 c4 10             	add    $0x10,%esp
}
8010490e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104911:	89 f8                	mov    %edi,%eax
80104913:	5b                   	pop    %ebx
80104914:	5e                   	pop    %esi
80104915:	5f                   	pop    %edi
80104916:	5d                   	pop    %ebp
80104917:	c3                   	ret    
80104918:	90                   	nop
80104919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80104920:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104924:	83 ec 08             	sub    $0x8,%esp
80104927:	50                   	push   %eax
80104928:	ff 36                	pushl  (%esi)
8010492a:	e8 d1 cb ff ff       	call   80101500 <ialloc>
8010492f:	83 c4 10             	add    $0x10,%esp
80104932:	85 c0                	test   %eax,%eax
80104934:	89 c7                	mov    %eax,%edi
80104936:	0f 84 cc 00 00 00    	je     80104a08 <create+0x188>
  ilock(ip);
8010493c:	83 ec 0c             	sub    $0xc,%esp
8010493f:	50                   	push   %eax
80104940:	e8 2b cd ff ff       	call   80101670 <ilock>
  ip->major = major;
80104945:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104949:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010494d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104951:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104955:	b8 01 00 00 00       	mov    $0x1,%eax
8010495a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010495e:	89 3c 24             	mov    %edi,(%esp)
80104961:	e8 5a cc ff ff       	call   801015c0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104966:	83 c4 10             	add    $0x10,%esp
80104969:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010496e:	74 40                	je     801049b0 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80104970:	83 ec 04             	sub    $0x4,%esp
80104973:	ff 77 04             	pushl  0x4(%edi)
80104976:	53                   	push   %ebx
80104977:	56                   	push   %esi
80104978:	e8 83 d4 ff ff       	call   80101e00 <dirlink>
8010497d:	83 c4 10             	add    $0x10,%esp
80104980:	85 c0                	test   %eax,%eax
80104982:	78 77                	js     801049fb <create+0x17b>
  iunlockput(dp);
80104984:	83 ec 0c             	sub    $0xc,%esp
80104987:	56                   	push   %esi
80104988:	e8 73 cf ff ff       	call   80101900 <iunlockput>
  return ip;
8010498d:	83 c4 10             	add    $0x10,%esp
}
80104990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104993:	89 f8                	mov    %edi,%eax
80104995:	5b                   	pop    %ebx
80104996:	5e                   	pop    %esi
80104997:	5f                   	pop    %edi
80104998:	5d                   	pop    %ebp
80104999:	c3                   	ret    
8010499a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return 0;
801049a0:	31 ff                	xor    %edi,%edi
801049a2:	e9 47 ff ff ff       	jmp    801048ee <create+0x6e>
801049a7:	89 f6                	mov    %esi,%esi
801049a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    dp->nlink++;  // for ".."
801049b0:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
801049b5:	83 ec 0c             	sub    $0xc,%esp
801049b8:	56                   	push   %esi
801049b9:	e8 02 cc ff ff       	call   801015c0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801049be:	83 c4 0c             	add    $0xc,%esp
801049c1:	ff 77 04             	pushl  0x4(%edi)
801049c4:	68 98 76 10 80       	push   $0x80107698
801049c9:	57                   	push   %edi
801049ca:	e8 31 d4 ff ff       	call   80101e00 <dirlink>
801049cf:	83 c4 10             	add    $0x10,%esp
801049d2:	85 c0                	test   %eax,%eax
801049d4:	78 18                	js     801049ee <create+0x16e>
801049d6:	83 ec 04             	sub    $0x4,%esp
801049d9:	ff 76 04             	pushl  0x4(%esi)
801049dc:	68 97 76 10 80       	push   $0x80107697
801049e1:	57                   	push   %edi
801049e2:	e8 19 d4 ff ff       	call   80101e00 <dirlink>
801049e7:	83 c4 10             	add    $0x10,%esp
801049ea:	85 c0                	test   %eax,%eax
801049ec:	79 82                	jns    80104970 <create+0xf0>
      panic("create dots");
801049ee:	83 ec 0c             	sub    $0xc,%esp
801049f1:	68 8b 76 10 80       	push   $0x8010768b
801049f6:	e8 75 b9 ff ff       	call   80100370 <panic>
    panic("create: dirlink");
801049fb:	83 ec 0c             	sub    $0xc,%esp
801049fe:	68 9a 76 10 80       	push   $0x8010769a
80104a03:	e8 68 b9 ff ff       	call   80100370 <panic>
    panic("create: ialloc");
80104a08:	83 ec 0c             	sub    $0xc,%esp
80104a0b:	68 7c 76 10 80       	push   $0x8010767c
80104a10:	e8 5b b9 ff ff       	call   80100370 <panic>
80104a15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a20 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	53                   	push   %ebx
80104a25:	89 c6                	mov    %eax,%esi
  if(argint(n, &fd) < 0)
80104a27:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104a2a:	89 d3                	mov    %edx,%ebx
80104a2c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104a2f:	50                   	push   %eax
80104a30:	6a 00                	push   $0x0
80104a32:	e8 f9 fc ff ff       	call   80104730 <argint>
80104a37:	83 c4 10             	add    $0x10,%esp
80104a3a:	85 c0                	test   %eax,%eax
80104a3c:	78 32                	js     80104a70 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104a3e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104a42:	77 2c                	ja     80104a70 <argfd.constprop.0+0x50>
80104a44:	e8 47 ed ff ff       	call   80103790 <myproc>
80104a49:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a4c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104a50:	85 c0                	test   %eax,%eax
80104a52:	74 1c                	je     80104a70 <argfd.constprop.0+0x50>
  if(pfd)
80104a54:	85 f6                	test   %esi,%esi
80104a56:	74 02                	je     80104a5a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104a58:	89 16                	mov    %edx,(%esi)
  if(pf)
80104a5a:	85 db                	test   %ebx,%ebx
80104a5c:	74 22                	je     80104a80 <argfd.constprop.0+0x60>
    *pf = f;
80104a5e:	89 03                	mov    %eax,(%ebx)
  return 0;
80104a60:	31 c0                	xor    %eax,%eax
}
80104a62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a65:	5b                   	pop    %ebx
80104a66:	5e                   	pop    %esi
80104a67:	5d                   	pop    %ebp
80104a68:	c3                   	ret    
80104a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a70:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104a73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a78:	5b                   	pop    %ebx
80104a79:	5e                   	pop    %esi
80104a7a:	5d                   	pop    %ebp
80104a7b:	c3                   	ret    
80104a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
80104a80:	31 c0                	xor    %eax,%eax
80104a82:	eb de                	jmp    80104a62 <argfd.constprop.0+0x42>
80104a84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a90 <sys_dup>:
{
80104a90:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104a91:	31 c0                	xor    %eax,%eax
{
80104a93:	89 e5                	mov    %esp,%ebp
80104a95:	56                   	push   %esi
80104a96:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104a97:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104a9a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104a9d:	e8 7e ff ff ff       	call   80104a20 <argfd.constprop.0>
80104aa2:	85 c0                	test   %eax,%eax
80104aa4:	78 1a                	js     80104ac0 <sys_dup+0x30>
  for(fd = 0; fd < NOFILE; fd++){
80104aa6:	31 db                	xor    %ebx,%ebx
  if((fd=fdalloc(f)) < 0)
80104aa8:	8b 75 f4             	mov    -0xc(%ebp),%esi
  struct proc *curproc = myproc();
80104aab:	e8 e0 ec ff ff       	call   80103790 <myproc>
    if(curproc->ofile[fd] == 0){
80104ab0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104ab4:	85 d2                	test   %edx,%edx
80104ab6:	74 18                	je     80104ad0 <sys_dup+0x40>
  for(fd = 0; fd < NOFILE; fd++){
80104ab8:	83 c3 01             	add    $0x1,%ebx
80104abb:	83 fb 10             	cmp    $0x10,%ebx
80104abe:	75 f0                	jne    80104ab0 <sys_dup+0x20>
}
80104ac0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104ac3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104ac8:	89 d8                	mov    %ebx,%eax
80104aca:	5b                   	pop    %ebx
80104acb:	5e                   	pop    %esi
80104acc:	5d                   	pop    %ebp
80104acd:	c3                   	ret    
80104ace:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80104ad0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104ad4:	83 ec 0c             	sub    $0xc,%esp
80104ad7:	ff 75 f4             	pushl  -0xc(%ebp)
80104ada:	e8 f1 c2 ff ff       	call   80100dd0 <filedup>
  return fd;
80104adf:	83 c4 10             	add    $0x10,%esp
}
80104ae2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ae5:	89 d8                	mov    %ebx,%eax
80104ae7:	5b                   	pop    %ebx
80104ae8:	5e                   	pop    %esi
80104ae9:	5d                   	pop    %ebp
80104aea:	c3                   	ret    
80104aeb:	90                   	nop
80104aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104af0 <sys_read>:
{
80104af0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104af1:	31 c0                	xor    %eax,%eax
{
80104af3:	89 e5                	mov    %esp,%ebp
80104af5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104af8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104afb:	e8 20 ff ff ff       	call   80104a20 <argfd.constprop.0>
80104b00:	85 c0                	test   %eax,%eax
80104b02:	78 4c                	js     80104b50 <sys_read+0x60>
80104b04:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b07:	83 ec 08             	sub    $0x8,%esp
80104b0a:	50                   	push   %eax
80104b0b:	6a 02                	push   $0x2
80104b0d:	e8 1e fc ff ff       	call   80104730 <argint>
80104b12:	83 c4 10             	add    $0x10,%esp
80104b15:	85 c0                	test   %eax,%eax
80104b17:	78 37                	js     80104b50 <sys_read+0x60>
80104b19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b1c:	83 ec 04             	sub    $0x4,%esp
80104b1f:	ff 75 f0             	pushl  -0x10(%ebp)
80104b22:	50                   	push   %eax
80104b23:	6a 01                	push   $0x1
80104b25:	e8 56 fc ff ff       	call   80104780 <argptr>
80104b2a:	83 c4 10             	add    $0x10,%esp
80104b2d:	85 c0                	test   %eax,%eax
80104b2f:	78 1f                	js     80104b50 <sys_read+0x60>
  return fileread(f, p, n);
80104b31:	83 ec 04             	sub    $0x4,%esp
80104b34:	ff 75 f0             	pushl  -0x10(%ebp)
80104b37:	ff 75 f4             	pushl  -0xc(%ebp)
80104b3a:	ff 75 ec             	pushl  -0x14(%ebp)
80104b3d:	e8 fe c3 ff ff       	call   80100f40 <fileread>
80104b42:	83 c4 10             	add    $0x10,%esp
}
80104b45:	c9                   	leave  
80104b46:	c3                   	ret    
80104b47:	89 f6                	mov    %esi,%esi
80104b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b55:	c9                   	leave  
80104b56:	c3                   	ret    
80104b57:	89 f6                	mov    %esi,%esi
80104b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b60 <sys_write>:
{
80104b60:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b61:	31 c0                	xor    %eax,%eax
{
80104b63:	89 e5                	mov    %esp,%ebp
80104b65:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b68:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b6b:	e8 b0 fe ff ff       	call   80104a20 <argfd.constprop.0>
80104b70:	85 c0                	test   %eax,%eax
80104b72:	78 4c                	js     80104bc0 <sys_write+0x60>
80104b74:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b77:	83 ec 08             	sub    $0x8,%esp
80104b7a:	50                   	push   %eax
80104b7b:	6a 02                	push   $0x2
80104b7d:	e8 ae fb ff ff       	call   80104730 <argint>
80104b82:	83 c4 10             	add    $0x10,%esp
80104b85:	85 c0                	test   %eax,%eax
80104b87:	78 37                	js     80104bc0 <sys_write+0x60>
80104b89:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b8c:	83 ec 04             	sub    $0x4,%esp
80104b8f:	ff 75 f0             	pushl  -0x10(%ebp)
80104b92:	50                   	push   %eax
80104b93:	6a 01                	push   $0x1
80104b95:	e8 e6 fb ff ff       	call   80104780 <argptr>
80104b9a:	83 c4 10             	add    $0x10,%esp
80104b9d:	85 c0                	test   %eax,%eax
80104b9f:	78 1f                	js     80104bc0 <sys_write+0x60>
  return filewrite(f, p, n);
80104ba1:	83 ec 04             	sub    $0x4,%esp
80104ba4:	ff 75 f0             	pushl  -0x10(%ebp)
80104ba7:	ff 75 f4             	pushl  -0xc(%ebp)
80104baa:	ff 75 ec             	pushl  -0x14(%ebp)
80104bad:	e8 1e c4 ff ff       	call   80100fd0 <filewrite>
80104bb2:	83 c4 10             	add    $0x10,%esp
}
80104bb5:	c9                   	leave  
80104bb6:	c3                   	ret    
80104bb7:	89 f6                	mov    %esi,%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bc5:	c9                   	leave  
80104bc6:	c3                   	ret    
80104bc7:	89 f6                	mov    %esi,%esi
80104bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bd0 <sys_close>:
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104bd6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104bd9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bdc:	e8 3f fe ff ff       	call   80104a20 <argfd.constprop.0>
80104be1:	85 c0                	test   %eax,%eax
80104be3:	78 2b                	js     80104c10 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104be5:	e8 a6 eb ff ff       	call   80103790 <myproc>
80104bea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104bed:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104bf0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104bf7:	00 
  fileclose(f);
80104bf8:	ff 75 f4             	pushl  -0xc(%ebp)
80104bfb:	e8 20 c2 ff ff       	call   80100e20 <fileclose>
  return 0;
80104c00:	83 c4 10             	add    $0x10,%esp
80104c03:	31 c0                	xor    %eax,%eax
}
80104c05:	c9                   	leave  
80104c06:	c3                   	ret    
80104c07:	89 f6                	mov    %esi,%esi
80104c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c15:	c9                   	leave  
80104c16:	c3                   	ret    
80104c17:	89 f6                	mov    %esi,%esi
80104c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c20 <sys_fstat>:
{
80104c20:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c21:	31 c0                	xor    %eax,%eax
{
80104c23:	89 e5                	mov    %esp,%ebp
80104c25:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c28:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104c2b:	e8 f0 fd ff ff       	call   80104a20 <argfd.constprop.0>
80104c30:	85 c0                	test   %eax,%eax
80104c32:	78 2c                	js     80104c60 <sys_fstat+0x40>
80104c34:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c37:	83 ec 04             	sub    $0x4,%esp
80104c3a:	6a 14                	push   $0x14
80104c3c:	50                   	push   %eax
80104c3d:	6a 01                	push   $0x1
80104c3f:	e8 3c fb ff ff       	call   80104780 <argptr>
80104c44:	83 c4 10             	add    $0x10,%esp
80104c47:	85 c0                	test   %eax,%eax
80104c49:	78 15                	js     80104c60 <sys_fstat+0x40>
  return filestat(f, st);
80104c4b:	83 ec 08             	sub    $0x8,%esp
80104c4e:	ff 75 f4             	pushl  -0xc(%ebp)
80104c51:	ff 75 f0             	pushl  -0x10(%ebp)
80104c54:	e8 97 c2 ff ff       	call   80100ef0 <filestat>
80104c59:	83 c4 10             	add    $0x10,%esp
}
80104c5c:	c9                   	leave  
80104c5d:	c3                   	ret    
80104c5e:	66 90                	xchg   %ax,%ax
    return -1;
80104c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c65:	c9                   	leave  
80104c66:	c3                   	ret    
80104c67:	89 f6                	mov    %esi,%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <sys_link>:
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	57                   	push   %edi
80104c74:	56                   	push   %esi
80104c75:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104c76:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104c79:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104c7c:	50                   	push   %eax
80104c7d:	6a 00                	push   $0x0
80104c7f:	e8 5c fb ff ff       	call   801047e0 <argstr>
80104c84:	83 c4 10             	add    $0x10,%esp
80104c87:	85 c0                	test   %eax,%eax
80104c89:	0f 88 fb 00 00 00    	js     80104d8a <sys_link+0x11a>
80104c8f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104c92:	83 ec 08             	sub    $0x8,%esp
80104c95:	50                   	push   %eax
80104c96:	6a 01                	push   $0x1
80104c98:	e8 43 fb ff ff       	call   801047e0 <argstr>
80104c9d:	83 c4 10             	add    $0x10,%esp
80104ca0:	85 c0                	test   %eax,%eax
80104ca2:	0f 88 e2 00 00 00    	js     80104d8a <sys_link+0x11a>
  begin_op();
80104ca8:	e8 c3 de ff ff       	call   80102b70 <begin_op>
  if((ip = namei(old)) == 0){
80104cad:	83 ec 0c             	sub    $0xc,%esp
80104cb0:	ff 75 d4             	pushl  -0x2c(%ebp)
80104cb3:	e8 08 d2 ff ff       	call   80101ec0 <namei>
80104cb8:	83 c4 10             	add    $0x10,%esp
80104cbb:	85 c0                	test   %eax,%eax
80104cbd:	89 c3                	mov    %eax,%ebx
80104cbf:	0f 84 f3 00 00 00    	je     80104db8 <sys_link+0x148>
  ilock(ip);
80104cc5:	83 ec 0c             	sub    $0xc,%esp
80104cc8:	50                   	push   %eax
80104cc9:	e8 a2 c9 ff ff       	call   80101670 <ilock>
  if(ip->type == T_DIR){
80104cce:	83 c4 10             	add    $0x10,%esp
80104cd1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104cd6:	0f 84 c4 00 00 00    	je     80104da0 <sys_link+0x130>
  ip->nlink++;
80104cdc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ce1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80104ce4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104ce7:	53                   	push   %ebx
80104ce8:	e8 d3 c8 ff ff       	call   801015c0 <iupdate>
  iunlock(ip);
80104ced:	89 1c 24             	mov    %ebx,(%esp)
80104cf0:	e8 5b ca ff ff       	call   80101750 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104cf5:	58                   	pop    %eax
80104cf6:	5a                   	pop    %edx
80104cf7:	57                   	push   %edi
80104cf8:	ff 75 d0             	pushl  -0x30(%ebp)
80104cfb:	e8 e0 d1 ff ff       	call   80101ee0 <nameiparent>
80104d00:	83 c4 10             	add    $0x10,%esp
80104d03:	85 c0                	test   %eax,%eax
80104d05:	89 c6                	mov    %eax,%esi
80104d07:	74 5b                	je     80104d64 <sys_link+0xf4>
  ilock(dp);
80104d09:	83 ec 0c             	sub    $0xc,%esp
80104d0c:	50                   	push   %eax
80104d0d:	e8 5e c9 ff ff       	call   80101670 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104d12:	83 c4 10             	add    $0x10,%esp
80104d15:	8b 03                	mov    (%ebx),%eax
80104d17:	39 06                	cmp    %eax,(%esi)
80104d19:	75 3d                	jne    80104d58 <sys_link+0xe8>
80104d1b:	83 ec 04             	sub    $0x4,%esp
80104d1e:	ff 73 04             	pushl  0x4(%ebx)
80104d21:	57                   	push   %edi
80104d22:	56                   	push   %esi
80104d23:	e8 d8 d0 ff ff       	call   80101e00 <dirlink>
80104d28:	83 c4 10             	add    $0x10,%esp
80104d2b:	85 c0                	test   %eax,%eax
80104d2d:	78 29                	js     80104d58 <sys_link+0xe8>
  iunlockput(dp);
80104d2f:	83 ec 0c             	sub    $0xc,%esp
80104d32:	56                   	push   %esi
80104d33:	e8 c8 cb ff ff       	call   80101900 <iunlockput>
  iput(ip);
80104d38:	89 1c 24             	mov    %ebx,(%esp)
80104d3b:	e8 60 ca ff ff       	call   801017a0 <iput>
  end_op();
80104d40:	e8 9b de ff ff       	call   80102be0 <end_op>
  return 0;
80104d45:	83 c4 10             	add    $0x10,%esp
80104d48:	31 c0                	xor    %eax,%eax
}
80104d4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d4d:	5b                   	pop    %ebx
80104d4e:	5e                   	pop    %esi
80104d4f:	5f                   	pop    %edi
80104d50:	5d                   	pop    %ebp
80104d51:	c3                   	ret    
80104d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104d58:	83 ec 0c             	sub    $0xc,%esp
80104d5b:	56                   	push   %esi
80104d5c:	e8 9f cb ff ff       	call   80101900 <iunlockput>
    goto bad;
80104d61:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104d64:	83 ec 0c             	sub    $0xc,%esp
80104d67:	53                   	push   %ebx
80104d68:	e8 03 c9 ff ff       	call   80101670 <ilock>
  ip->nlink--;
80104d6d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d72:	89 1c 24             	mov    %ebx,(%esp)
80104d75:	e8 46 c8 ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
80104d7a:	89 1c 24             	mov    %ebx,(%esp)
80104d7d:	e8 7e cb ff ff       	call   80101900 <iunlockput>
  end_op();
80104d82:	e8 59 de ff ff       	call   80102be0 <end_op>
  return -1;
80104d87:	83 c4 10             	add    $0x10,%esp
}
80104d8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104d8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d92:	5b                   	pop    %ebx
80104d93:	5e                   	pop    %esi
80104d94:	5f                   	pop    %edi
80104d95:	5d                   	pop    %ebp
80104d96:	c3                   	ret    
80104d97:	89 f6                	mov    %esi,%esi
80104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80104da0:	83 ec 0c             	sub    $0xc,%esp
80104da3:	53                   	push   %ebx
80104da4:	e8 57 cb ff ff       	call   80101900 <iunlockput>
    end_op();
80104da9:	e8 32 de ff ff       	call   80102be0 <end_op>
    return -1;
80104dae:	83 c4 10             	add    $0x10,%esp
80104db1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104db6:	eb 92                	jmp    80104d4a <sys_link+0xda>
    end_op();
80104db8:	e8 23 de ff ff       	call   80102be0 <end_op>
    return -1;
80104dbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dc2:	eb 86                	jmp    80104d4a <sys_link+0xda>
80104dc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104dca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104dd0 <sys_unlink>:
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	57                   	push   %edi
80104dd4:	56                   	push   %esi
80104dd5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80104dd6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104dd9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104ddc:	50                   	push   %eax
80104ddd:	6a 00                	push   $0x0
80104ddf:	e8 fc f9 ff ff       	call   801047e0 <argstr>
80104de4:	83 c4 10             	add    $0x10,%esp
80104de7:	85 c0                	test   %eax,%eax
80104de9:	0f 88 82 01 00 00    	js     80104f71 <sys_unlink+0x1a1>
  if((dp = nameiparent(path, name)) == 0){
80104def:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80104df2:	e8 79 dd ff ff       	call   80102b70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104df7:	83 ec 08             	sub    $0x8,%esp
80104dfa:	53                   	push   %ebx
80104dfb:	ff 75 c0             	pushl  -0x40(%ebp)
80104dfe:	e8 dd d0 ff ff       	call   80101ee0 <nameiparent>
80104e03:	83 c4 10             	add    $0x10,%esp
80104e06:	85 c0                	test   %eax,%eax
80104e08:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104e0b:	0f 84 6a 01 00 00    	je     80104f7b <sys_unlink+0x1ab>
  ilock(dp);
80104e11:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104e14:	83 ec 0c             	sub    $0xc,%esp
80104e17:	56                   	push   %esi
80104e18:	e8 53 c8 ff ff       	call   80101670 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104e1d:	58                   	pop    %eax
80104e1e:	5a                   	pop    %edx
80104e1f:	68 98 76 10 80       	push   $0x80107698
80104e24:	53                   	push   %ebx
80104e25:	e8 56 cd ff ff       	call   80101b80 <namecmp>
80104e2a:	83 c4 10             	add    $0x10,%esp
80104e2d:	85 c0                	test   %eax,%eax
80104e2f:	0f 84 fc 00 00 00    	je     80104f31 <sys_unlink+0x161>
80104e35:	83 ec 08             	sub    $0x8,%esp
80104e38:	68 97 76 10 80       	push   $0x80107697
80104e3d:	53                   	push   %ebx
80104e3e:	e8 3d cd ff ff       	call   80101b80 <namecmp>
80104e43:	83 c4 10             	add    $0x10,%esp
80104e46:	85 c0                	test   %eax,%eax
80104e48:	0f 84 e3 00 00 00    	je     80104f31 <sys_unlink+0x161>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104e4e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104e51:	83 ec 04             	sub    $0x4,%esp
80104e54:	50                   	push   %eax
80104e55:	53                   	push   %ebx
80104e56:	56                   	push   %esi
80104e57:	e8 44 cd ff ff       	call   80101ba0 <dirlookup>
80104e5c:	83 c4 10             	add    $0x10,%esp
80104e5f:	85 c0                	test   %eax,%eax
80104e61:	89 c3                	mov    %eax,%ebx
80104e63:	0f 84 c8 00 00 00    	je     80104f31 <sys_unlink+0x161>
  ilock(ip);
80104e69:	83 ec 0c             	sub    $0xc,%esp
80104e6c:	50                   	push   %eax
80104e6d:	e8 fe c7 ff ff       	call   80101670 <ilock>
  if(ip->nlink < 1)
80104e72:	83 c4 10             	add    $0x10,%esp
80104e75:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104e7a:	0f 8e 24 01 00 00    	jle    80104fa4 <sys_unlink+0x1d4>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104e80:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e85:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104e88:	74 66                	je     80104ef0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80104e8a:	83 ec 04             	sub    $0x4,%esp
80104e8d:	6a 10                	push   $0x10
80104e8f:	6a 00                	push   $0x0
80104e91:	56                   	push   %esi
80104e92:	e8 a9 f5 ff ff       	call   80104440 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104e97:	6a 10                	push   $0x10
80104e99:	ff 75 c4             	pushl  -0x3c(%ebp)
80104e9c:	56                   	push   %esi
80104e9d:	ff 75 b4             	pushl  -0x4c(%ebp)
80104ea0:	e8 ab cb ff ff       	call   80101a50 <writei>
80104ea5:	83 c4 20             	add    $0x20,%esp
80104ea8:	83 f8 10             	cmp    $0x10,%eax
80104eab:	0f 85 e6 00 00 00    	jne    80104f97 <sys_unlink+0x1c7>
  if(ip->type == T_DIR){
80104eb1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104eb6:	0f 84 9c 00 00 00    	je     80104f58 <sys_unlink+0x188>
  iunlockput(dp);
80104ebc:	83 ec 0c             	sub    $0xc,%esp
80104ebf:	ff 75 b4             	pushl  -0x4c(%ebp)
80104ec2:	e8 39 ca ff ff       	call   80101900 <iunlockput>
  ip->nlink--;
80104ec7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ecc:	89 1c 24             	mov    %ebx,(%esp)
80104ecf:	e8 ec c6 ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
80104ed4:	89 1c 24             	mov    %ebx,(%esp)
80104ed7:	e8 24 ca ff ff       	call   80101900 <iunlockput>
  end_op();
80104edc:	e8 ff dc ff ff       	call   80102be0 <end_op>
  return 0;
80104ee1:	83 c4 10             	add    $0x10,%esp
80104ee4:	31 c0                	xor    %eax,%eax
}
80104ee6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ee9:	5b                   	pop    %ebx
80104eea:	5e                   	pop    %esi
80104eeb:	5f                   	pop    %edi
80104eec:	5d                   	pop    %ebp
80104eed:	c3                   	ret    
80104eee:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104ef0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104ef4:	76 94                	jbe    80104e8a <sys_unlink+0xba>
80104ef6:	bf 20 00 00 00       	mov    $0x20,%edi
80104efb:	eb 0f                	jmp    80104f0c <sys_unlink+0x13c>
80104efd:	8d 76 00             	lea    0x0(%esi),%esi
80104f00:	83 c7 10             	add    $0x10,%edi
80104f03:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104f06:	0f 83 7e ff ff ff    	jae    80104e8a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f0c:	6a 10                	push   $0x10
80104f0e:	57                   	push   %edi
80104f0f:	56                   	push   %esi
80104f10:	53                   	push   %ebx
80104f11:	e8 3a ca ff ff       	call   80101950 <readi>
80104f16:	83 c4 10             	add    $0x10,%esp
80104f19:	83 f8 10             	cmp    $0x10,%eax
80104f1c:	75 6c                	jne    80104f8a <sys_unlink+0x1ba>
    if(de.inum != 0)
80104f1e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104f23:	74 db                	je     80104f00 <sys_unlink+0x130>
    iunlockput(ip);
80104f25:	83 ec 0c             	sub    $0xc,%esp
80104f28:	53                   	push   %ebx
80104f29:	e8 d2 c9 ff ff       	call   80101900 <iunlockput>
    goto bad;
80104f2e:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80104f31:	83 ec 0c             	sub    $0xc,%esp
80104f34:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f37:	e8 c4 c9 ff ff       	call   80101900 <iunlockput>
  end_op();
80104f3c:	e8 9f dc ff ff       	call   80102be0 <end_op>
  return -1;
80104f41:	83 c4 10             	add    $0x10,%esp
}
80104f44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104f47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f4c:	5b                   	pop    %ebx
80104f4d:	5e                   	pop    %esi
80104f4e:	5f                   	pop    %edi
80104f4f:	5d                   	pop    %ebp
80104f50:	c3                   	ret    
80104f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80104f58:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80104f5b:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80104f5e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104f63:	50                   	push   %eax
80104f64:	e8 57 c6 ff ff       	call   801015c0 <iupdate>
80104f69:	83 c4 10             	add    $0x10,%esp
80104f6c:	e9 4b ff ff ff       	jmp    80104ebc <sys_unlink+0xec>
    return -1;
80104f71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f76:	e9 6b ff ff ff       	jmp    80104ee6 <sys_unlink+0x116>
    end_op();
80104f7b:	e8 60 dc ff ff       	call   80102be0 <end_op>
    return -1;
80104f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f85:	e9 5c ff ff ff       	jmp    80104ee6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80104f8a:	83 ec 0c             	sub    $0xc,%esp
80104f8d:	68 bc 76 10 80       	push   $0x801076bc
80104f92:	e8 d9 b3 ff ff       	call   80100370 <panic>
    panic("unlink: writei");
80104f97:	83 ec 0c             	sub    $0xc,%esp
80104f9a:	68 ce 76 10 80       	push   $0x801076ce
80104f9f:	e8 cc b3 ff ff       	call   80100370 <panic>
    panic("unlink: nlink < 1");
80104fa4:	83 ec 0c             	sub    $0xc,%esp
80104fa7:	68 aa 76 10 80       	push   $0x801076aa
80104fac:	e8 bf b3 ff ff       	call   80100370 <panic>
80104fb1:	eb 0d                	jmp    80104fc0 <sys_open>
80104fb3:	90                   	nop
80104fb4:	90                   	nop
80104fb5:	90                   	nop
80104fb6:	90                   	nop
80104fb7:	90                   	nop
80104fb8:	90                   	nop
80104fb9:	90                   	nop
80104fba:	90                   	nop
80104fbb:	90                   	nop
80104fbc:	90                   	nop
80104fbd:	90                   	nop
80104fbe:	90                   	nop
80104fbf:	90                   	nop

80104fc0 <sys_open>:

int
sys_open(void)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	57                   	push   %edi
80104fc4:	56                   	push   %esi
80104fc5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104fc6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80104fc9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104fcc:	50                   	push   %eax
80104fcd:	6a 00                	push   $0x0
80104fcf:	e8 0c f8 ff ff       	call   801047e0 <argstr>
80104fd4:	83 c4 10             	add    $0x10,%esp
80104fd7:	85 c0                	test   %eax,%eax
80104fd9:	0f 88 9e 00 00 00    	js     8010507d <sys_open+0xbd>
80104fdf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104fe2:	83 ec 08             	sub    $0x8,%esp
80104fe5:	50                   	push   %eax
80104fe6:	6a 01                	push   $0x1
80104fe8:	e8 43 f7 ff ff       	call   80104730 <argint>
80104fed:	83 c4 10             	add    $0x10,%esp
80104ff0:	85 c0                	test   %eax,%eax
80104ff2:	0f 88 85 00 00 00    	js     8010507d <sys_open+0xbd>
    return -1;

  begin_op();
80104ff8:	e8 73 db ff ff       	call   80102b70 <begin_op>

  if(omode & O_CREATE){
80104ffd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105001:	0f 85 89 00 00 00    	jne    80105090 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105007:	83 ec 0c             	sub    $0xc,%esp
8010500a:	ff 75 e0             	pushl  -0x20(%ebp)
8010500d:	e8 ae ce ff ff       	call   80101ec0 <namei>
80105012:	83 c4 10             	add    $0x10,%esp
80105015:	85 c0                	test   %eax,%eax
80105017:	89 c6                	mov    %eax,%esi
80105019:	0f 84 8e 00 00 00    	je     801050ad <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010501f:	83 ec 0c             	sub    $0xc,%esp
80105022:	50                   	push   %eax
80105023:	e8 48 c6 ff ff       	call   80101670 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105028:	83 c4 10             	add    $0x10,%esp
8010502b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105030:	0f 84 d2 00 00 00    	je     80105108 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105036:	e8 25 bd ff ff       	call   80100d60 <filealloc>
8010503b:	85 c0                	test   %eax,%eax
8010503d:	89 c7                	mov    %eax,%edi
8010503f:	74 2b                	je     8010506c <sys_open+0xac>
  for(fd = 0; fd < NOFILE; fd++){
80105041:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105043:	e8 48 e7 ff ff       	call   80103790 <myproc>
80105048:	90                   	nop
80105049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105050:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105054:	85 d2                	test   %edx,%edx
80105056:	74 68                	je     801050c0 <sys_open+0x100>
  for(fd = 0; fd < NOFILE; fd++){
80105058:	83 c3 01             	add    $0x1,%ebx
8010505b:	83 fb 10             	cmp    $0x10,%ebx
8010505e:	75 f0                	jne    80105050 <sys_open+0x90>
    if(f)
      fileclose(f);
80105060:	83 ec 0c             	sub    $0xc,%esp
80105063:	57                   	push   %edi
80105064:	e8 b7 bd ff ff       	call   80100e20 <fileclose>
80105069:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010506c:	83 ec 0c             	sub    $0xc,%esp
8010506f:	56                   	push   %esi
80105070:	e8 8b c8 ff ff       	call   80101900 <iunlockput>
    end_op();
80105075:	e8 66 db ff ff       	call   80102be0 <end_op>
    return -1;
8010507a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010507d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105080:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105085:	89 d8                	mov    %ebx,%eax
80105087:	5b                   	pop    %ebx
80105088:	5e                   	pop    %esi
80105089:	5f                   	pop    %edi
8010508a:	5d                   	pop    %ebp
8010508b:	c3                   	ret    
8010508c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105090:	83 ec 0c             	sub    $0xc,%esp
80105093:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105096:	31 c9                	xor    %ecx,%ecx
80105098:	6a 00                	push   $0x0
8010509a:	ba 02 00 00 00       	mov    $0x2,%edx
8010509f:	e8 dc f7 ff ff       	call   80104880 <create>
    if(ip == 0){
801050a4:	83 c4 10             	add    $0x10,%esp
801050a7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801050a9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801050ab:	75 89                	jne    80105036 <sys_open+0x76>
      end_op();
801050ad:	e8 2e db ff ff       	call   80102be0 <end_op>
      return -1;
801050b2:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801050b7:	eb 40                	jmp    801050f9 <sys_open+0x139>
801050b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801050c0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801050c3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801050c7:	56                   	push   %esi
801050c8:	e8 83 c6 ff ff       	call   80101750 <iunlock>
  end_op();
801050cd:	e8 0e db ff ff       	call   80102be0 <end_op>
  f->type = FD_INODE;
801050d2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->readable = !(omode & O_WRONLY);
801050d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801050db:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801050de:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801050e1:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801050e8:	89 c2                	mov    %eax,%edx
801050ea:	f7 d2                	not    %edx
801050ec:	88 57 08             	mov    %dl,0x8(%edi)
801050ef:	80 67 08 01          	andb   $0x1,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801050f3:	a8 03                	test   $0x3,%al
801050f5:	0f 95 47 09          	setne  0x9(%edi)
}
801050f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050fc:	89 d8                	mov    %ebx,%eax
801050fe:	5b                   	pop    %ebx
801050ff:	5e                   	pop    %esi
80105100:	5f                   	pop    %edi
80105101:	5d                   	pop    %ebp
80105102:	c3                   	ret    
80105103:	90                   	nop
80105104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105108:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010510b:	85 c9                	test   %ecx,%ecx
8010510d:	0f 84 23 ff ff ff    	je     80105036 <sys_open+0x76>
80105113:	e9 54 ff ff ff       	jmp    8010506c <sys_open+0xac>
80105118:	90                   	nop
80105119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105120 <sys_mkdir>:

int
sys_mkdir(void)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105126:	e8 45 da ff ff       	call   80102b70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010512b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010512e:	83 ec 08             	sub    $0x8,%esp
80105131:	50                   	push   %eax
80105132:	6a 00                	push   $0x0
80105134:	e8 a7 f6 ff ff       	call   801047e0 <argstr>
80105139:	83 c4 10             	add    $0x10,%esp
8010513c:	85 c0                	test   %eax,%eax
8010513e:	78 30                	js     80105170 <sys_mkdir+0x50>
80105140:	83 ec 0c             	sub    $0xc,%esp
80105143:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105146:	31 c9                	xor    %ecx,%ecx
80105148:	6a 00                	push   $0x0
8010514a:	ba 01 00 00 00       	mov    $0x1,%edx
8010514f:	e8 2c f7 ff ff       	call   80104880 <create>
80105154:	83 c4 10             	add    $0x10,%esp
80105157:	85 c0                	test   %eax,%eax
80105159:	74 15                	je     80105170 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010515b:	83 ec 0c             	sub    $0xc,%esp
8010515e:	50                   	push   %eax
8010515f:	e8 9c c7 ff ff       	call   80101900 <iunlockput>
  end_op();
80105164:	e8 77 da ff ff       	call   80102be0 <end_op>
  return 0;
80105169:	83 c4 10             	add    $0x10,%esp
8010516c:	31 c0                	xor    %eax,%eax
}
8010516e:	c9                   	leave  
8010516f:	c3                   	ret    
    end_op();
80105170:	e8 6b da ff ff       	call   80102be0 <end_op>
    return -1;
80105175:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010517a:	c9                   	leave  
8010517b:	c3                   	ret    
8010517c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105180 <sys_mknod>:

int
sys_mknod(void)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105186:	e8 e5 d9 ff ff       	call   80102b70 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010518b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010518e:	83 ec 08             	sub    $0x8,%esp
80105191:	50                   	push   %eax
80105192:	6a 00                	push   $0x0
80105194:	e8 47 f6 ff ff       	call   801047e0 <argstr>
80105199:	83 c4 10             	add    $0x10,%esp
8010519c:	85 c0                	test   %eax,%eax
8010519e:	78 60                	js     80105200 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801051a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051a3:	83 ec 08             	sub    $0x8,%esp
801051a6:	50                   	push   %eax
801051a7:	6a 01                	push   $0x1
801051a9:	e8 82 f5 ff ff       	call   80104730 <argint>
  if((argstr(0, &path)) < 0 ||
801051ae:	83 c4 10             	add    $0x10,%esp
801051b1:	85 c0                	test   %eax,%eax
801051b3:	78 4b                	js     80105200 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801051b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051b8:	83 ec 08             	sub    $0x8,%esp
801051bb:	50                   	push   %eax
801051bc:	6a 02                	push   $0x2
801051be:	e8 6d f5 ff ff       	call   80104730 <argint>
     argint(1, &major) < 0 ||
801051c3:	83 c4 10             	add    $0x10,%esp
801051c6:	85 c0                	test   %eax,%eax
801051c8:	78 36                	js     80105200 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801051ca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801051ce:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801051d1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801051d5:	ba 03 00 00 00       	mov    $0x3,%edx
801051da:	50                   	push   %eax
801051db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801051de:	e8 9d f6 ff ff       	call   80104880 <create>
801051e3:	83 c4 10             	add    $0x10,%esp
801051e6:	85 c0                	test   %eax,%eax
801051e8:	74 16                	je     80105200 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801051ea:	83 ec 0c             	sub    $0xc,%esp
801051ed:	50                   	push   %eax
801051ee:	e8 0d c7 ff ff       	call   80101900 <iunlockput>
  end_op();
801051f3:	e8 e8 d9 ff ff       	call   80102be0 <end_op>
  return 0;
801051f8:	83 c4 10             	add    $0x10,%esp
801051fb:	31 c0                	xor    %eax,%eax
}
801051fd:	c9                   	leave  
801051fe:	c3                   	ret    
801051ff:	90                   	nop
    end_op();
80105200:	e8 db d9 ff ff       	call   80102be0 <end_op>
    return -1;
80105205:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010520a:	c9                   	leave  
8010520b:	c3                   	ret    
8010520c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105210 <sys_chdir>:

int
sys_chdir(void)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	56                   	push   %esi
80105214:	53                   	push   %ebx
80105215:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105218:	e8 73 e5 ff ff       	call   80103790 <myproc>
8010521d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010521f:	e8 4c d9 ff ff       	call   80102b70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105224:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105227:	83 ec 08             	sub    $0x8,%esp
8010522a:	50                   	push   %eax
8010522b:	6a 00                	push   $0x0
8010522d:	e8 ae f5 ff ff       	call   801047e0 <argstr>
80105232:	83 c4 10             	add    $0x10,%esp
80105235:	85 c0                	test   %eax,%eax
80105237:	78 77                	js     801052b0 <sys_chdir+0xa0>
80105239:	83 ec 0c             	sub    $0xc,%esp
8010523c:	ff 75 f4             	pushl  -0xc(%ebp)
8010523f:	e8 7c cc ff ff       	call   80101ec0 <namei>
80105244:	83 c4 10             	add    $0x10,%esp
80105247:	85 c0                	test   %eax,%eax
80105249:	89 c3                	mov    %eax,%ebx
8010524b:	74 63                	je     801052b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010524d:	83 ec 0c             	sub    $0xc,%esp
80105250:	50                   	push   %eax
80105251:	e8 1a c4 ff ff       	call   80101670 <ilock>
  if(ip->type != T_DIR){
80105256:	83 c4 10             	add    $0x10,%esp
80105259:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010525e:	75 30                	jne    80105290 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105260:	83 ec 0c             	sub    $0xc,%esp
80105263:	53                   	push   %ebx
80105264:	e8 e7 c4 ff ff       	call   80101750 <iunlock>
  iput(curproc->cwd);
80105269:	58                   	pop    %eax
8010526a:	ff 76 68             	pushl  0x68(%esi)
8010526d:	e8 2e c5 ff ff       	call   801017a0 <iput>
  end_op();
80105272:	e8 69 d9 ff ff       	call   80102be0 <end_op>
  curproc->cwd = ip;
80105277:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010527a:	83 c4 10             	add    $0x10,%esp
8010527d:	31 c0                	xor    %eax,%eax
}
8010527f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105282:	5b                   	pop    %ebx
80105283:	5e                   	pop    %esi
80105284:	5d                   	pop    %ebp
80105285:	c3                   	ret    
80105286:	8d 76 00             	lea    0x0(%esi),%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105290:	83 ec 0c             	sub    $0xc,%esp
80105293:	53                   	push   %ebx
80105294:	e8 67 c6 ff ff       	call   80101900 <iunlockput>
    end_op();
80105299:	e8 42 d9 ff ff       	call   80102be0 <end_op>
    return -1;
8010529e:	83 c4 10             	add    $0x10,%esp
801052a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a6:	eb d7                	jmp    8010527f <sys_chdir+0x6f>
801052a8:	90                   	nop
801052a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801052b0:	e8 2b d9 ff ff       	call   80102be0 <end_op>
    return -1;
801052b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ba:	eb c3                	jmp    8010527f <sys_chdir+0x6f>
801052bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052c0 <sys_exec>:

int
sys_exec(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	57                   	push   %edi
801052c4:	56                   	push   %esi
801052c5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801052c6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801052cc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801052d2:	50                   	push   %eax
801052d3:	6a 00                	push   $0x0
801052d5:	e8 06 f5 ff ff       	call   801047e0 <argstr>
801052da:	83 c4 10             	add    $0x10,%esp
801052dd:	85 c0                	test   %eax,%eax
801052df:	78 7f                	js     80105360 <sys_exec+0xa0>
801052e1:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801052e7:	83 ec 08             	sub    $0x8,%esp
801052ea:	50                   	push   %eax
801052eb:	6a 01                	push   $0x1
801052ed:	e8 3e f4 ff ff       	call   80104730 <argint>
801052f2:	83 c4 10             	add    $0x10,%esp
801052f5:	85 c0                	test   %eax,%eax
801052f7:	78 67                	js     80105360 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801052f9:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801052ff:	83 ec 04             	sub    $0x4,%esp
80105302:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105308:	68 80 00 00 00       	push   $0x80
8010530d:	6a 00                	push   $0x0
8010530f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105315:	50                   	push   %eax
80105316:	31 db                	xor    %ebx,%ebx
80105318:	e8 23 f1 ff ff       	call   80104440 <memset>
8010531d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105320:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105326:	83 ec 08             	sub    $0x8,%esp
80105329:	57                   	push   %edi
8010532a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010532d:	50                   	push   %eax
8010532e:	e8 5d f3 ff ff       	call   80104690 <fetchint>
80105333:	83 c4 10             	add    $0x10,%esp
80105336:	85 c0                	test   %eax,%eax
80105338:	78 26                	js     80105360 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010533a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105340:	85 c0                	test   %eax,%eax
80105342:	74 2c                	je     80105370 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105344:	83 ec 08             	sub    $0x8,%esp
80105347:	56                   	push   %esi
80105348:	50                   	push   %eax
80105349:	e8 82 f3 ff ff       	call   801046d0 <fetchstr>
8010534e:	83 c4 10             	add    $0x10,%esp
80105351:	85 c0                	test   %eax,%eax
80105353:	78 0b                	js     80105360 <sys_exec+0xa0>
  for(i=0;; i++){
80105355:	83 c3 01             	add    $0x1,%ebx
80105358:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
8010535b:	83 fb 20             	cmp    $0x20,%ebx
8010535e:	75 c0                	jne    80105320 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105360:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105363:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105368:	5b                   	pop    %ebx
80105369:	5e                   	pop    %esi
8010536a:	5f                   	pop    %edi
8010536b:	5d                   	pop    %ebp
8010536c:	c3                   	ret    
8010536d:	8d 76 00             	lea    0x0(%esi),%esi
  return exec(path, argv);
80105370:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105376:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105379:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105380:	00 00 00 00 
  return exec(path, argv);
80105384:	50                   	push   %eax
80105385:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010538b:	e8 50 b6 ff ff       	call   801009e0 <exec>
80105390:	83 c4 10             	add    $0x10,%esp
}
80105393:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105396:	5b                   	pop    %ebx
80105397:	5e                   	pop    %esi
80105398:	5f                   	pop    %edi
80105399:	5d                   	pop    %ebp
8010539a:	c3                   	ret    
8010539b:	90                   	nop
8010539c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053a0 <sys_pipe>:

int
sys_pipe(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	57                   	push   %edi
801053a4:	56                   	push   %esi
801053a5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801053a6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801053a9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801053ac:	6a 08                	push   $0x8
801053ae:	50                   	push   %eax
801053af:	6a 00                	push   $0x0
801053b1:	e8 ca f3 ff ff       	call   80104780 <argptr>
801053b6:	83 c4 10             	add    $0x10,%esp
801053b9:	85 c0                	test   %eax,%eax
801053bb:	78 4a                	js     80105407 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801053bd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801053c0:	83 ec 08             	sub    $0x8,%esp
801053c3:	50                   	push   %eax
801053c4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801053c7:	50                   	push   %eax
801053c8:	e8 33 de ff ff       	call   80103200 <pipealloc>
801053cd:	83 c4 10             	add    $0x10,%esp
801053d0:	85 c0                	test   %eax,%eax
801053d2:	78 33                	js     80105407 <sys_pipe+0x67>
  for(fd = 0; fd < NOFILE; fd++){
801053d4:	31 db                	xor    %ebx,%ebx
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801053d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
  struct proc *curproc = myproc();
801053d9:	e8 b2 e3 ff ff       	call   80103790 <myproc>
801053de:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801053e0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801053e4:	85 f6                	test   %esi,%esi
801053e6:	74 30                	je     80105418 <sys_pipe+0x78>
  for(fd = 0; fd < NOFILE; fd++){
801053e8:	83 c3 01             	add    $0x1,%ebx
801053eb:	83 fb 10             	cmp    $0x10,%ebx
801053ee:	75 f0                	jne    801053e0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801053f0:	83 ec 0c             	sub    $0xc,%esp
801053f3:	ff 75 e0             	pushl  -0x20(%ebp)
801053f6:	e8 25 ba ff ff       	call   80100e20 <fileclose>
    fileclose(wf);
801053fb:	58                   	pop    %eax
801053fc:	ff 75 e4             	pushl  -0x1c(%ebp)
801053ff:	e8 1c ba ff ff       	call   80100e20 <fileclose>
    return -1;
80105404:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105407:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010540a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010540f:	5b                   	pop    %ebx
80105410:	5e                   	pop    %esi
80105411:	5f                   	pop    %edi
80105412:	5d                   	pop    %ebp
80105413:	c3                   	ret    
80105414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105418:	8d 73 08             	lea    0x8(%ebx),%esi
8010541b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010541f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105422:	e8 69 e3 ff ff       	call   80103790 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105427:	31 d2                	xor    %edx,%edx
80105429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105430:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105434:	85 c9                	test   %ecx,%ecx
80105436:	74 18                	je     80105450 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105438:	83 c2 01             	add    $0x1,%edx
8010543b:	83 fa 10             	cmp    $0x10,%edx
8010543e:	75 f0                	jne    80105430 <sys_pipe+0x90>
      myproc()->ofile[fd0] = 0;
80105440:	e8 4b e3 ff ff       	call   80103790 <myproc>
80105445:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
8010544c:	00 
8010544d:	eb a1                	jmp    801053f0 <sys_pipe+0x50>
8010544f:	90                   	nop
      curproc->ofile[fd] = f;
80105450:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  fd[0] = fd0;
80105454:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105457:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105459:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010545c:	89 50 04             	mov    %edx,0x4(%eax)
}
8010545f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80105462:	31 c0                	xor    %eax,%eax
}
80105464:	5b                   	pop    %ebx
80105465:	5e                   	pop    %esi
80105466:	5f                   	pop    %edi
80105467:	5d                   	pop    %ebp
80105468:	c3                   	ret    
80105469:	66 90                	xchg   %ax,%ax
8010546b:	66 90                	xchg   %ax,%ax
8010546d:	66 90                	xchg   %ax,%ax
8010546f:	90                   	nop

80105470 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105473:	5d                   	pop    %ebp
  return fork();
80105474:	e9 b7 e4 ff ff       	jmp    80103930 <fork>
80105479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105480 <sys_exit>:

int
sys_exit(void)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	83 ec 08             	sub    $0x8,%esp
  exit();
80105486:	e8 45 e7 ff ff       	call   80103bd0 <exit>
  return 0;  // not reached
}
8010548b:	31 c0                	xor    %eax,%eax
8010548d:	c9                   	leave  
8010548e:	c3                   	ret    
8010548f:	90                   	nop

80105490 <sys_wait>:

int
sys_wait(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105493:	5d                   	pop    %ebp
  return wait();
80105494:	e9 77 e9 ff ff       	jmp    80103e10 <wait>
80105499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054a0 <sys_kill>:

int
sys_kill(void)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801054a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054a9:	50                   	push   %eax
801054aa:	6a 00                	push   $0x0
801054ac:	e8 7f f2 ff ff       	call   80104730 <argint>
801054b1:	83 c4 10             	add    $0x10,%esp
801054b4:	85 c0                	test   %eax,%eax
801054b6:	78 18                	js     801054d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801054b8:	83 ec 0c             	sub    $0xc,%esp
801054bb:	ff 75 f4             	pushl  -0xc(%ebp)
801054be:	e8 ad ea ff ff       	call   80103f70 <kill>
801054c3:	83 c4 10             	add    $0x10,%esp
}
801054c6:	c9                   	leave  
801054c7:	c3                   	ret    
801054c8:	90                   	nop
801054c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801054d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054d5:	c9                   	leave  
801054d6:	c3                   	ret    
801054d7:	89 f6                	mov    %esi,%esi
801054d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054e0 <sys_getpid>:

int
sys_getpid(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801054e6:	e8 a5 e2 ff ff       	call   80103790 <myproc>
801054eb:	8b 40 10             	mov    0x10(%eax),%eax
}
801054ee:	c9                   	leave  
801054ef:	c3                   	ret    

801054f0 <sys_sbrk>:

int
sys_sbrk(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801054f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801054f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801054fa:	50                   	push   %eax
801054fb:	6a 00                	push   $0x0
801054fd:	e8 2e f2 ff ff       	call   80104730 <argint>
80105502:	83 c4 10             	add    $0x10,%esp
80105505:	85 c0                	test   %eax,%eax
80105507:	78 27                	js     80105530 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105509:	e8 82 e2 ff ff       	call   80103790 <myproc>
  if(growproc(n) < 0)
8010550e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105511:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105513:	ff 75 f4             	pushl  -0xc(%ebp)
80105516:	e8 95 e3 ff ff       	call   801038b0 <growproc>
8010551b:	83 c4 10             	add    $0x10,%esp
8010551e:	85 c0                	test   %eax,%eax
80105520:	78 0e                	js     80105530 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105522:	89 d8                	mov    %ebx,%eax
80105524:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105527:	c9                   	leave  
80105528:	c3                   	ret    
80105529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105530:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105535:	eb eb                	jmp    80105522 <sys_sbrk+0x32>
80105537:	89 f6                	mov    %esi,%esi
80105539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105540 <sys_sleep>:

int
sys_sleep(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105544:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105547:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010554a:	50                   	push   %eax
8010554b:	6a 00                	push   $0x0
8010554d:	e8 de f1 ff ff       	call   80104730 <argint>
80105552:	83 c4 10             	add    $0x10,%esp
80105555:	85 c0                	test   %eax,%eax
80105557:	0f 88 8a 00 00 00    	js     801055e7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010555d:	83 ec 0c             	sub    $0xc,%esp
80105560:	68 60 4c 11 80       	push   $0x80114c60
80105565:	e8 66 ed ff ff       	call   801042d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010556a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010556d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105570:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
80105576:	85 d2                	test   %edx,%edx
80105578:	75 27                	jne    801055a1 <sys_sleep+0x61>
8010557a:	eb 54                	jmp    801055d0 <sys_sleep+0x90>
8010557c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105580:	83 ec 08             	sub    $0x8,%esp
80105583:	68 60 4c 11 80       	push   $0x80114c60
80105588:	68 a0 54 11 80       	push   $0x801154a0
8010558d:	e8 be e7 ff ff       	call   80103d50 <sleep>
  while(ticks - ticks0 < n){
80105592:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80105597:	83 c4 10             	add    $0x10,%esp
8010559a:	29 d8                	sub    %ebx,%eax
8010559c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010559f:	73 2f                	jae    801055d0 <sys_sleep+0x90>
    if(myproc()->killed){
801055a1:	e8 ea e1 ff ff       	call   80103790 <myproc>
801055a6:	8b 40 24             	mov    0x24(%eax),%eax
801055a9:	85 c0                	test   %eax,%eax
801055ab:	74 d3                	je     80105580 <sys_sleep+0x40>
      release(&tickslock);
801055ad:	83 ec 0c             	sub    $0xc,%esp
801055b0:	68 60 4c 11 80       	push   $0x80114c60
801055b5:	e8 36 ee ff ff       	call   801043f0 <release>
      return -1;
801055ba:	83 c4 10             	add    $0x10,%esp
801055bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801055c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055c5:	c9                   	leave  
801055c6:	c3                   	ret    
801055c7:	89 f6                	mov    %esi,%esi
801055c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	68 60 4c 11 80       	push   $0x80114c60
801055d8:	e8 13 ee ff ff       	call   801043f0 <release>
  return 0;
801055dd:	83 c4 10             	add    $0x10,%esp
801055e0:	31 c0                	xor    %eax,%eax
}
801055e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055e5:	c9                   	leave  
801055e6:	c3                   	ret    
    return -1;
801055e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ec:	eb d4                	jmp    801055c2 <sys_sleep+0x82>
801055ee:	66 90                	xchg   %ax,%ax

801055f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	53                   	push   %ebx
801055f4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801055f7:	68 60 4c 11 80       	push   $0x80114c60
801055fc:	e8 cf ec ff ff       	call   801042d0 <acquire>
  xticks = ticks;
80105601:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
80105607:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010560e:	e8 dd ed ff ff       	call   801043f0 <release>
  return xticks;
}
80105613:	89 d8                	mov    %ebx,%eax
80105615:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105618:	c9                   	leave  
80105619:	c3                   	ret    
8010561a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105620 <my_sleep>:
void my_sleep(int n)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	56                   	push   %esi
80105624:	53                   	push   %ebx
80105625:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint ticks0;
  n = n * 50;
  
  acquire(&tickslock);
80105628:	83 ec 0c             	sub    $0xc,%esp
8010562b:	68 60 4c 11 80       	push   $0x80114c60
  n = n * 50;
80105630:	6b db 32             	imul   $0x32,%ebx,%ebx
  acquire(&tickslock);
80105633:	e8 98 ec ff ff       	call   801042d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105638:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
8010563b:	8b 35 a0 54 11 80    	mov    0x801154a0,%esi
  while(ticks - ticks0 < n){
80105641:	85 db                	test   %ebx,%ebx
80105643:	75 2b                	jne    80105670 <my_sleep+0x50>
80105645:	eb 35                	jmp    8010567c <my_sleep+0x5c>
80105647:	89 f6                	mov    %esi,%esi
80105649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(myproc()->killed){
      release(&tickslock);
      return;
    }
    sleep(&ticks, &tickslock);
80105650:	83 ec 08             	sub    $0x8,%esp
80105653:	68 60 4c 11 80       	push   $0x80114c60
80105658:	68 a0 54 11 80       	push   $0x801154a0
8010565d:	e8 ee e6 ff ff       	call   80103d50 <sleep>
  while(ticks - ticks0 < n){
80105662:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80105667:	83 c4 10             	add    $0x10,%esp
8010566a:	29 f0                	sub    %esi,%eax
8010566c:	39 d8                	cmp    %ebx,%eax
8010566e:	73 0c                	jae    8010567c <my_sleep+0x5c>
    if(myproc()->killed){
80105670:	e8 1b e1 ff ff       	call   80103790 <myproc>
80105675:	8b 40 24             	mov    0x24(%eax),%eax
80105678:	85 c0                	test   %eax,%eax
8010567a:	74 d4                	je     80105650 <my_sleep+0x30>
      release(&tickslock);
8010567c:	c7 45 08 60 4c 11 80 	movl   $0x80114c60,0x8(%ebp)
  }
  release(&tickslock);
}
80105683:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105686:	5b                   	pop    %ebx
80105687:	5e                   	pop    %esi
80105688:	5d                   	pop    %ebp
      release(&tickslock);
80105689:	e9 62 ed ff ff       	jmp    801043f0 <release>
8010568e:	66 90                	xchg   %ax,%ax

80105690 <sys_shutdown2>:

int
sys_shutdown2(void)
{
80105690:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105691:	ba 04 b0 ff ff       	mov    $0xffffb004,%edx
80105696:	b8 00 20 00 00       	mov    $0x2000,%eax
8010569b:	89 e5                	mov    %esp,%ebp
8010569d:	66 ef                	out    %ax,(%dx)
8010569f:	ba 04 06 00 00       	mov    $0x604,%edx
801056a4:	66 ef                	out    %ax,(%dx)
	outw(0xB004, 0x0|0x2000);
	outw(0x604, 0x0|0x2000);
	return 0;
}
801056a6:	31 c0                	xor    %eax,%eax
801056a8:	5d                   	pop    %ebp
801056a9:	c3                   	ret    

801056aa <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801056aa:	1e                   	push   %ds
  pushl %es
801056ab:	06                   	push   %es
  pushl %fs
801056ac:	0f a0                	push   %fs
  pushl %gs
801056ae:	0f a8                	push   %gs
  pushal
801056b0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801056b1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801056b5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801056b7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801056b9:	54                   	push   %esp
  call trap
801056ba:	e8 e1 00 00 00       	call   801057a0 <trap>
  addl $4, %esp
801056bf:	83 c4 04             	add    $0x4,%esp

801056c2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801056c2:	61                   	popa   
  popl %gs
801056c3:	0f a9                	pop    %gs
  popl %fs
801056c5:	0f a1                	pop    %fs
  popl %es
801056c7:	07                   	pop    %es
  popl %ds
801056c8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801056c9:	83 c4 08             	add    $0x8,%esp
  iret
801056cc:	cf                   	iret   
801056cd:	66 90                	xchg   %ax,%ax
801056cf:	90                   	nop

801056d0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801056d0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801056d1:	31 c0                	xor    %eax,%eax
{
801056d3:	89 e5                	mov    %esp,%ebp
801056d5:	83 ec 08             	sub    $0x8,%esp
801056d8:	90                   	nop
801056d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801056e0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801056e7:	b9 08 00 00 00       	mov    $0x8,%ecx
801056ec:	c6 04 c5 a4 4c 11 80 	movb   $0x0,-0x7feeb35c(,%eax,8)
801056f3:	00 
801056f4:	66 89 0c c5 a2 4c 11 	mov    %cx,-0x7feeb35e(,%eax,8)
801056fb:	80 
801056fc:	c6 04 c5 a5 4c 11 80 	movb   $0x8e,-0x7feeb35b(,%eax,8)
80105703:	8e 
80105704:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
8010570b:	80 
8010570c:	c1 ea 10             	shr    $0x10,%edx
8010570f:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
80105716:	80 
  for(i = 0; i < 256; i++)
80105717:	83 c0 01             	add    $0x1,%eax
8010571a:	3d 00 01 00 00       	cmp    $0x100,%eax
8010571f:	75 bf                	jne    801056e0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105721:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105726:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105729:	ba 08 00 00 00       	mov    $0x8,%edx
  initlock(&tickslock, "time");
8010572e:	68 dd 76 10 80       	push   $0x801076dd
80105733:	68 60 4c 11 80       	push   $0x80114c60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105738:	66 89 15 a2 4e 11 80 	mov    %dx,0x80114ea2
8010573f:	c6 05 a4 4e 11 80 00 	movb   $0x0,0x80114ea4
80105746:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
8010574c:	c1 e8 10             	shr    $0x10,%eax
8010574f:	c6 05 a5 4e 11 80 ef 	movb   $0xef,0x80114ea5
80105756:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6
  initlock(&tickslock, "time");
8010575c:	e8 6f ea ff ff       	call   801041d0 <initlock>
}
80105761:	83 c4 10             	add    $0x10,%esp
80105764:	c9                   	leave  
80105765:	c3                   	ret    
80105766:	8d 76 00             	lea    0x0(%esi),%esi
80105769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105770 <idtinit>:

void
idtinit(void)
{
80105770:	55                   	push   %ebp
  pd[0] = size-1;
80105771:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105776:	89 e5                	mov    %esp,%ebp
80105778:	83 ec 10             	sub    $0x10,%esp
8010577b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010577f:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
80105784:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105788:	c1 e8 10             	shr    $0x10,%eax
8010578b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010578f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105792:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105795:	c9                   	leave  
80105796:	c3                   	ret    
80105797:	89 f6                	mov    %esi,%esi
80105799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057a0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	57                   	push   %edi
801057a4:	56                   	push   %esi
801057a5:	53                   	push   %ebx
801057a6:	83 ec 1c             	sub    $0x1c,%esp
801057a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801057ac:	8b 47 30             	mov    0x30(%edi),%eax
801057af:	83 f8 40             	cmp    $0x40,%eax
801057b2:	0f 84 88 01 00 00    	je     80105940 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801057b8:	83 e8 20             	sub    $0x20,%eax
801057bb:	83 f8 1f             	cmp    $0x1f,%eax
801057be:	77 10                	ja     801057d0 <trap+0x30>
801057c0:	ff 24 85 84 77 10 80 	jmp    *-0x7fef887c(,%eax,4)
801057c7:	89 f6                	mov    %esi,%esi
801057c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801057d0:	e8 bb df ff ff       	call   80103790 <myproc>
801057d5:	85 c0                	test   %eax,%eax
801057d7:	0f 84 d7 01 00 00    	je     801059b4 <trap+0x214>
801057dd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801057e1:	0f 84 cd 01 00 00    	je     801059b4 <trap+0x214>
  asm volatile("movl %%cr2,%0" : "=r" (val));
801057e7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057ea:	8b 57 38             	mov    0x38(%edi),%edx
801057ed:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801057f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801057f3:	e8 78 df ff ff       	call   80103770 <cpuid>
801057f8:	8b 77 34             	mov    0x34(%edi),%esi
801057fb:	8b 5f 30             	mov    0x30(%edi),%ebx
801057fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105801:	e8 8a df ff ff       	call   80103790 <myproc>
80105806:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105809:	e8 82 df ff ff       	call   80103790 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010580e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105811:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105814:	51                   	push   %ecx
80105815:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105816:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105819:	ff 75 e4             	pushl  -0x1c(%ebp)
8010581c:	56                   	push   %esi
8010581d:	53                   	push   %ebx
            myproc()->pid, myproc()->name, tf->trapno,
8010581e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105821:	52                   	push   %edx
80105822:	ff 70 10             	pushl  0x10(%eax)
80105825:	68 40 77 10 80       	push   $0x80107740
8010582a:	e8 31 ae ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010582f:	83 c4 20             	add    $0x20,%esp
80105832:	e8 59 df ff ff       	call   80103790 <myproc>
80105837:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010583e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105840:	e8 4b df ff ff       	call   80103790 <myproc>
80105845:	85 c0                	test   %eax,%eax
80105847:	74 0c                	je     80105855 <trap+0xb5>
80105849:	e8 42 df ff ff       	call   80103790 <myproc>
8010584e:	8b 50 24             	mov    0x24(%eax),%edx
80105851:	85 d2                	test   %edx,%edx
80105853:	75 4b                	jne    801058a0 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105855:	e8 36 df ff ff       	call   80103790 <myproc>
8010585a:	85 c0                	test   %eax,%eax
8010585c:	74 0b                	je     80105869 <trap+0xc9>
8010585e:	e8 2d df ff ff       	call   80103790 <myproc>
80105863:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105867:	74 4f                	je     801058b8 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105869:	e8 22 df ff ff       	call   80103790 <myproc>
8010586e:	85 c0                	test   %eax,%eax
80105870:	74 1d                	je     8010588f <trap+0xef>
80105872:	e8 19 df ff ff       	call   80103790 <myproc>
80105877:	8b 40 24             	mov    0x24(%eax),%eax
8010587a:	85 c0                	test   %eax,%eax
8010587c:	74 11                	je     8010588f <trap+0xef>
8010587e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105882:	83 e0 03             	and    $0x3,%eax
80105885:	66 83 f8 03          	cmp    $0x3,%ax
80105889:	0f 84 da 00 00 00    	je     80105969 <trap+0x1c9>
    exit();
}
8010588f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105892:	5b                   	pop    %ebx
80105893:	5e                   	pop    %esi
80105894:	5f                   	pop    %edi
80105895:	5d                   	pop    %ebp
80105896:	c3                   	ret    
80105897:	89 f6                	mov    %esi,%esi
80105899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058a0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801058a4:	83 e0 03             	and    $0x3,%eax
801058a7:	66 83 f8 03          	cmp    $0x3,%ax
801058ab:	75 a8                	jne    80105855 <trap+0xb5>
    exit();
801058ad:	e8 1e e3 ff ff       	call   80103bd0 <exit>
801058b2:	eb a1                	jmp    80105855 <trap+0xb5>
801058b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
801058b8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801058bc:	75 ab                	jne    80105869 <trap+0xc9>
    yield();
801058be:	e8 3d e4 ff ff       	call   80103d00 <yield>
801058c3:	eb a4                	jmp    80105869 <trap+0xc9>
801058c5:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
801058c8:	e8 a3 de ff ff       	call   80103770 <cpuid>
801058cd:	85 c0                	test   %eax,%eax
801058cf:	0f 84 ab 00 00 00    	je     80105980 <trap+0x1e0>
    lapiceoi();
801058d5:	e8 46 ce ff ff       	call   80102720 <lapiceoi>
    break;
801058da:	e9 61 ff ff ff       	jmp    80105840 <trap+0xa0>
801058df:	90                   	nop
    kbdintr();
801058e0:	e8 fb cc ff ff       	call   801025e0 <kbdintr>
    lapiceoi();
801058e5:	e8 36 ce ff ff       	call   80102720 <lapiceoi>
    break;
801058ea:	e9 51 ff ff ff       	jmp    80105840 <trap+0xa0>
801058ef:	90                   	nop
    uartintr();
801058f0:	e8 5b 02 00 00       	call   80105b50 <uartintr>
    lapiceoi();
801058f5:	e8 26 ce ff ff       	call   80102720 <lapiceoi>
    break;
801058fa:	e9 41 ff ff ff       	jmp    80105840 <trap+0xa0>
801058ff:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105900:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105904:	8b 77 38             	mov    0x38(%edi),%esi
80105907:	e8 64 de ff ff       	call   80103770 <cpuid>
8010590c:	56                   	push   %esi
8010590d:	53                   	push   %ebx
8010590e:	50                   	push   %eax
8010590f:	68 e8 76 10 80       	push   $0x801076e8
80105914:	e8 47 ad ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105919:	e8 02 ce ff ff       	call   80102720 <lapiceoi>
    break;
8010591e:	83 c4 10             	add    $0x10,%esp
80105921:	e9 1a ff ff ff       	jmp    80105840 <trap+0xa0>
80105926:	8d 76 00             	lea    0x0(%esi),%esi
80105929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80105930:	e8 1b c7 ff ff       	call   80102050 <ideintr>
80105935:	eb 9e                	jmp    801058d5 <trap+0x135>
80105937:	89 f6                	mov    %esi,%esi
80105939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(myproc()->killed)
80105940:	e8 4b de ff ff       	call   80103790 <myproc>
80105945:	8b 58 24             	mov    0x24(%eax),%ebx
80105948:	85 db                	test   %ebx,%ebx
8010594a:	75 2c                	jne    80105978 <trap+0x1d8>
    myproc()->tf = tf;
8010594c:	e8 3f de ff ff       	call   80103790 <myproc>
80105951:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105954:	e8 c7 ee ff ff       	call   80104820 <syscall>
    if(myproc()->killed)
80105959:	e8 32 de ff ff       	call   80103790 <myproc>
8010595e:	8b 48 24             	mov    0x24(%eax),%ecx
80105961:	85 c9                	test   %ecx,%ecx
80105963:	0f 84 26 ff ff ff    	je     8010588f <trap+0xef>
}
80105969:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010596c:	5b                   	pop    %ebx
8010596d:	5e                   	pop    %esi
8010596e:	5f                   	pop    %edi
8010596f:	5d                   	pop    %ebp
      exit();
80105970:	e9 5b e2 ff ff       	jmp    80103bd0 <exit>
80105975:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
80105978:	e8 53 e2 ff ff       	call   80103bd0 <exit>
8010597d:	eb cd                	jmp    8010594c <trap+0x1ac>
8010597f:	90                   	nop
      acquire(&tickslock);
80105980:	83 ec 0c             	sub    $0xc,%esp
80105983:	68 60 4c 11 80       	push   $0x80114c60
80105988:	e8 43 e9 ff ff       	call   801042d0 <acquire>
      wakeup(&ticks);
8010598d:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
      ticks++;
80105994:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
8010599b:	e8 70 e5 ff ff       	call   80103f10 <wakeup>
      release(&tickslock);
801059a0:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801059a7:	e8 44 ea ff ff       	call   801043f0 <release>
801059ac:	83 c4 10             	add    $0x10,%esp
801059af:	e9 21 ff ff ff       	jmp    801058d5 <trap+0x135>
801059b4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801059b7:	8b 5f 38             	mov    0x38(%edi),%ebx
801059ba:	e8 b1 dd ff ff       	call   80103770 <cpuid>
801059bf:	83 ec 0c             	sub    $0xc,%esp
801059c2:	56                   	push   %esi
801059c3:	53                   	push   %ebx
801059c4:	50                   	push   %eax
801059c5:	ff 77 30             	pushl  0x30(%edi)
801059c8:	68 0c 77 10 80       	push   $0x8010770c
801059cd:	e8 8e ac ff ff       	call   80100660 <cprintf>
      panic("trap");
801059d2:	83 c4 14             	add    $0x14,%esp
801059d5:	68 e2 76 10 80       	push   $0x801076e2
801059da:	e8 91 a9 ff ff       	call   80100370 <panic>
801059df:	90                   	nop

801059e0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801059e0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
801059e5:	55                   	push   %ebp
801059e6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801059e8:	85 c0                	test   %eax,%eax
801059ea:	74 1c                	je     80105a08 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801059ec:	ba fd 03 00 00       	mov    $0x3fd,%edx
801059f1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801059f2:	a8 01                	test   $0x1,%al
801059f4:	74 12                	je     80105a08 <uartgetc+0x28>
801059f6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801059fb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801059fc:	0f b6 c0             	movzbl %al,%eax
}
801059ff:	5d                   	pop    %ebp
80105a00:	c3                   	ret    
80105a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a0d:	5d                   	pop    %ebp
80105a0e:	c3                   	ret    
80105a0f:	90                   	nop

80105a10 <uartputc.part.0>:
uartputc(int c)
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	57                   	push   %edi
80105a14:	56                   	push   %esi
80105a15:	53                   	push   %ebx
80105a16:	89 c7                	mov    %eax,%edi
80105a18:	bb 80 00 00 00       	mov    $0x80,%ebx
80105a1d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105a22:	83 ec 0c             	sub    $0xc,%esp
80105a25:	eb 1b                	jmp    80105a42 <uartputc.part.0+0x32>
80105a27:	89 f6                	mov    %esi,%esi
80105a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105a30:	83 ec 0c             	sub    $0xc,%esp
80105a33:	6a 0a                	push   $0xa
80105a35:	e8 06 cd ff ff       	call   80102740 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105a3a:	83 c4 10             	add    $0x10,%esp
80105a3d:	83 eb 01             	sub    $0x1,%ebx
80105a40:	74 07                	je     80105a49 <uartputc.part.0+0x39>
80105a42:	89 f2                	mov    %esi,%edx
80105a44:	ec                   	in     (%dx),%al
80105a45:	a8 20                	test   $0x20,%al
80105a47:	74 e7                	je     80105a30 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105a49:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a4e:	89 f8                	mov    %edi,%eax
80105a50:	ee                   	out    %al,(%dx)
}
80105a51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a54:	5b                   	pop    %ebx
80105a55:	5e                   	pop    %esi
80105a56:	5f                   	pop    %edi
80105a57:	5d                   	pop    %ebp
80105a58:	c3                   	ret    
80105a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a60 <uartinit>:
{
80105a60:	55                   	push   %ebp
80105a61:	31 c9                	xor    %ecx,%ecx
80105a63:	89 c8                	mov    %ecx,%eax
80105a65:	89 e5                	mov    %esp,%ebp
80105a67:	57                   	push   %edi
80105a68:	56                   	push   %esi
80105a69:	53                   	push   %ebx
80105a6a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105a6f:	89 da                	mov    %ebx,%edx
80105a71:	83 ec 0c             	sub    $0xc,%esp
80105a74:	ee                   	out    %al,(%dx)
80105a75:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105a7a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105a7f:	89 fa                	mov    %edi,%edx
80105a81:	ee                   	out    %al,(%dx)
80105a82:	b8 0c 00 00 00       	mov    $0xc,%eax
80105a87:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a8c:	ee                   	out    %al,(%dx)
80105a8d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105a92:	89 c8                	mov    %ecx,%eax
80105a94:	89 f2                	mov    %esi,%edx
80105a96:	ee                   	out    %al,(%dx)
80105a97:	b8 03 00 00 00       	mov    $0x3,%eax
80105a9c:	89 fa                	mov    %edi,%edx
80105a9e:	ee                   	out    %al,(%dx)
80105a9f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105aa4:	89 c8                	mov    %ecx,%eax
80105aa6:	ee                   	out    %al,(%dx)
80105aa7:	b8 01 00 00 00       	mov    $0x1,%eax
80105aac:	89 f2                	mov    %esi,%edx
80105aae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105aaf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ab4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105ab5:	3c ff                	cmp    $0xff,%al
80105ab7:	74 5a                	je     80105b13 <uartinit+0xb3>
  uart = 1;
80105ab9:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105ac0:	00 00 00 
80105ac3:	89 da                	mov    %ebx,%edx
80105ac5:	ec                   	in     (%dx),%al
80105ac6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105acb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105acc:	83 ec 08             	sub    $0x8,%esp
80105acf:	bb 04 78 10 80       	mov    $0x80107804,%ebx
80105ad4:	6a 00                	push   $0x0
80105ad6:	6a 04                	push   $0x4
80105ad8:	e8 c3 c7 ff ff       	call   801022a0 <ioapicenable>
80105add:	83 c4 10             	add    $0x10,%esp
80105ae0:	b8 78 00 00 00       	mov    $0x78,%eax
80105ae5:	eb 13                	jmp    80105afa <uartinit+0x9a>
80105ae7:	89 f6                	mov    %esi,%esi
80105ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(p="xv6...\n"; *p; p++)
80105af0:	83 c3 01             	add    $0x1,%ebx
80105af3:	0f be 03             	movsbl (%ebx),%eax
80105af6:	84 c0                	test   %al,%al
80105af8:	74 19                	je     80105b13 <uartinit+0xb3>
  if(!uart)
80105afa:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105b00:	85 d2                	test   %edx,%edx
80105b02:	74 ec                	je     80105af0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105b04:	83 c3 01             	add    $0x1,%ebx
80105b07:	e8 04 ff ff ff       	call   80105a10 <uartputc.part.0>
80105b0c:	0f be 03             	movsbl (%ebx),%eax
80105b0f:	84 c0                	test   %al,%al
80105b11:	75 e7                	jne    80105afa <uartinit+0x9a>
}
80105b13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b16:	5b                   	pop    %ebx
80105b17:	5e                   	pop    %esi
80105b18:	5f                   	pop    %edi
80105b19:	5d                   	pop    %ebp
80105b1a:	c3                   	ret    
80105b1b:	90                   	nop
80105b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b20 <uartputc>:
  if(!uart)
80105b20:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105b26:	55                   	push   %ebp
80105b27:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105b29:	85 d2                	test   %edx,%edx
{
80105b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105b2e:	74 10                	je     80105b40 <uartputc+0x20>
}
80105b30:	5d                   	pop    %ebp
80105b31:	e9 da fe ff ff       	jmp    80105a10 <uartputc.part.0>
80105b36:	8d 76 00             	lea    0x0(%esi),%esi
80105b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105b40:	5d                   	pop    %ebp
80105b41:	c3                   	ret    
80105b42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b50 <uartintr>:

void
uartintr(void)
{
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105b56:	68 e0 59 10 80       	push   $0x801059e0
80105b5b:	e8 80 ac ff ff       	call   801007e0 <consoleintr>
}
80105b60:	83 c4 10             	add    $0x10,%esp
80105b63:	c9                   	leave  
80105b64:	c3                   	ret    

80105b65 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105b65:	6a 00                	push   $0x0
  pushl $0
80105b67:	6a 00                	push   $0x0
  jmp alltraps
80105b69:	e9 3c fb ff ff       	jmp    801056aa <alltraps>

80105b6e <vector1>:
.globl vector1
vector1:
  pushl $0
80105b6e:	6a 00                	push   $0x0
  pushl $1
80105b70:	6a 01                	push   $0x1
  jmp alltraps
80105b72:	e9 33 fb ff ff       	jmp    801056aa <alltraps>

80105b77 <vector2>:
.globl vector2
vector2:
  pushl $0
80105b77:	6a 00                	push   $0x0
  pushl $2
80105b79:	6a 02                	push   $0x2
  jmp alltraps
80105b7b:	e9 2a fb ff ff       	jmp    801056aa <alltraps>

80105b80 <vector3>:
.globl vector3
vector3:
  pushl $0
80105b80:	6a 00                	push   $0x0
  pushl $3
80105b82:	6a 03                	push   $0x3
  jmp alltraps
80105b84:	e9 21 fb ff ff       	jmp    801056aa <alltraps>

80105b89 <vector4>:
.globl vector4
vector4:
  pushl $0
80105b89:	6a 00                	push   $0x0
  pushl $4
80105b8b:	6a 04                	push   $0x4
  jmp alltraps
80105b8d:	e9 18 fb ff ff       	jmp    801056aa <alltraps>

80105b92 <vector5>:
.globl vector5
vector5:
  pushl $0
80105b92:	6a 00                	push   $0x0
  pushl $5
80105b94:	6a 05                	push   $0x5
  jmp alltraps
80105b96:	e9 0f fb ff ff       	jmp    801056aa <alltraps>

80105b9b <vector6>:
.globl vector6
vector6:
  pushl $0
80105b9b:	6a 00                	push   $0x0
  pushl $6
80105b9d:	6a 06                	push   $0x6
  jmp alltraps
80105b9f:	e9 06 fb ff ff       	jmp    801056aa <alltraps>

80105ba4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105ba4:	6a 00                	push   $0x0
  pushl $7
80105ba6:	6a 07                	push   $0x7
  jmp alltraps
80105ba8:	e9 fd fa ff ff       	jmp    801056aa <alltraps>

80105bad <vector8>:
.globl vector8
vector8:
  pushl $8
80105bad:	6a 08                	push   $0x8
  jmp alltraps
80105baf:	e9 f6 fa ff ff       	jmp    801056aa <alltraps>

80105bb4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105bb4:	6a 00                	push   $0x0
  pushl $9
80105bb6:	6a 09                	push   $0x9
  jmp alltraps
80105bb8:	e9 ed fa ff ff       	jmp    801056aa <alltraps>

80105bbd <vector10>:
.globl vector10
vector10:
  pushl $10
80105bbd:	6a 0a                	push   $0xa
  jmp alltraps
80105bbf:	e9 e6 fa ff ff       	jmp    801056aa <alltraps>

80105bc4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105bc4:	6a 0b                	push   $0xb
  jmp alltraps
80105bc6:	e9 df fa ff ff       	jmp    801056aa <alltraps>

80105bcb <vector12>:
.globl vector12
vector12:
  pushl $12
80105bcb:	6a 0c                	push   $0xc
  jmp alltraps
80105bcd:	e9 d8 fa ff ff       	jmp    801056aa <alltraps>

80105bd2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105bd2:	6a 0d                	push   $0xd
  jmp alltraps
80105bd4:	e9 d1 fa ff ff       	jmp    801056aa <alltraps>

80105bd9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105bd9:	6a 0e                	push   $0xe
  jmp alltraps
80105bdb:	e9 ca fa ff ff       	jmp    801056aa <alltraps>

80105be0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105be0:	6a 00                	push   $0x0
  pushl $15
80105be2:	6a 0f                	push   $0xf
  jmp alltraps
80105be4:	e9 c1 fa ff ff       	jmp    801056aa <alltraps>

80105be9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105be9:	6a 00                	push   $0x0
  pushl $16
80105beb:	6a 10                	push   $0x10
  jmp alltraps
80105bed:	e9 b8 fa ff ff       	jmp    801056aa <alltraps>

80105bf2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105bf2:	6a 11                	push   $0x11
  jmp alltraps
80105bf4:	e9 b1 fa ff ff       	jmp    801056aa <alltraps>

80105bf9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105bf9:	6a 00                	push   $0x0
  pushl $18
80105bfb:	6a 12                	push   $0x12
  jmp alltraps
80105bfd:	e9 a8 fa ff ff       	jmp    801056aa <alltraps>

80105c02 <vector19>:
.globl vector19
vector19:
  pushl $0
80105c02:	6a 00                	push   $0x0
  pushl $19
80105c04:	6a 13                	push   $0x13
  jmp alltraps
80105c06:	e9 9f fa ff ff       	jmp    801056aa <alltraps>

80105c0b <vector20>:
.globl vector20
vector20:
  pushl $0
80105c0b:	6a 00                	push   $0x0
  pushl $20
80105c0d:	6a 14                	push   $0x14
  jmp alltraps
80105c0f:	e9 96 fa ff ff       	jmp    801056aa <alltraps>

80105c14 <vector21>:
.globl vector21
vector21:
  pushl $0
80105c14:	6a 00                	push   $0x0
  pushl $21
80105c16:	6a 15                	push   $0x15
  jmp alltraps
80105c18:	e9 8d fa ff ff       	jmp    801056aa <alltraps>

80105c1d <vector22>:
.globl vector22
vector22:
  pushl $0
80105c1d:	6a 00                	push   $0x0
  pushl $22
80105c1f:	6a 16                	push   $0x16
  jmp alltraps
80105c21:	e9 84 fa ff ff       	jmp    801056aa <alltraps>

80105c26 <vector23>:
.globl vector23
vector23:
  pushl $0
80105c26:	6a 00                	push   $0x0
  pushl $23
80105c28:	6a 17                	push   $0x17
  jmp alltraps
80105c2a:	e9 7b fa ff ff       	jmp    801056aa <alltraps>

80105c2f <vector24>:
.globl vector24
vector24:
  pushl $0
80105c2f:	6a 00                	push   $0x0
  pushl $24
80105c31:	6a 18                	push   $0x18
  jmp alltraps
80105c33:	e9 72 fa ff ff       	jmp    801056aa <alltraps>

80105c38 <vector25>:
.globl vector25
vector25:
  pushl $0
80105c38:	6a 00                	push   $0x0
  pushl $25
80105c3a:	6a 19                	push   $0x19
  jmp alltraps
80105c3c:	e9 69 fa ff ff       	jmp    801056aa <alltraps>

80105c41 <vector26>:
.globl vector26
vector26:
  pushl $0
80105c41:	6a 00                	push   $0x0
  pushl $26
80105c43:	6a 1a                	push   $0x1a
  jmp alltraps
80105c45:	e9 60 fa ff ff       	jmp    801056aa <alltraps>

80105c4a <vector27>:
.globl vector27
vector27:
  pushl $0
80105c4a:	6a 00                	push   $0x0
  pushl $27
80105c4c:	6a 1b                	push   $0x1b
  jmp alltraps
80105c4e:	e9 57 fa ff ff       	jmp    801056aa <alltraps>

80105c53 <vector28>:
.globl vector28
vector28:
  pushl $0
80105c53:	6a 00                	push   $0x0
  pushl $28
80105c55:	6a 1c                	push   $0x1c
  jmp alltraps
80105c57:	e9 4e fa ff ff       	jmp    801056aa <alltraps>

80105c5c <vector29>:
.globl vector29
vector29:
  pushl $0
80105c5c:	6a 00                	push   $0x0
  pushl $29
80105c5e:	6a 1d                	push   $0x1d
  jmp alltraps
80105c60:	e9 45 fa ff ff       	jmp    801056aa <alltraps>

80105c65 <vector30>:
.globl vector30
vector30:
  pushl $0
80105c65:	6a 00                	push   $0x0
  pushl $30
80105c67:	6a 1e                	push   $0x1e
  jmp alltraps
80105c69:	e9 3c fa ff ff       	jmp    801056aa <alltraps>

80105c6e <vector31>:
.globl vector31
vector31:
  pushl $0
80105c6e:	6a 00                	push   $0x0
  pushl $31
80105c70:	6a 1f                	push   $0x1f
  jmp alltraps
80105c72:	e9 33 fa ff ff       	jmp    801056aa <alltraps>

80105c77 <vector32>:
.globl vector32
vector32:
  pushl $0
80105c77:	6a 00                	push   $0x0
  pushl $32
80105c79:	6a 20                	push   $0x20
  jmp alltraps
80105c7b:	e9 2a fa ff ff       	jmp    801056aa <alltraps>

80105c80 <vector33>:
.globl vector33
vector33:
  pushl $0
80105c80:	6a 00                	push   $0x0
  pushl $33
80105c82:	6a 21                	push   $0x21
  jmp alltraps
80105c84:	e9 21 fa ff ff       	jmp    801056aa <alltraps>

80105c89 <vector34>:
.globl vector34
vector34:
  pushl $0
80105c89:	6a 00                	push   $0x0
  pushl $34
80105c8b:	6a 22                	push   $0x22
  jmp alltraps
80105c8d:	e9 18 fa ff ff       	jmp    801056aa <alltraps>

80105c92 <vector35>:
.globl vector35
vector35:
  pushl $0
80105c92:	6a 00                	push   $0x0
  pushl $35
80105c94:	6a 23                	push   $0x23
  jmp alltraps
80105c96:	e9 0f fa ff ff       	jmp    801056aa <alltraps>

80105c9b <vector36>:
.globl vector36
vector36:
  pushl $0
80105c9b:	6a 00                	push   $0x0
  pushl $36
80105c9d:	6a 24                	push   $0x24
  jmp alltraps
80105c9f:	e9 06 fa ff ff       	jmp    801056aa <alltraps>

80105ca4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ca4:	6a 00                	push   $0x0
  pushl $37
80105ca6:	6a 25                	push   $0x25
  jmp alltraps
80105ca8:	e9 fd f9 ff ff       	jmp    801056aa <alltraps>

80105cad <vector38>:
.globl vector38
vector38:
  pushl $0
80105cad:	6a 00                	push   $0x0
  pushl $38
80105caf:	6a 26                	push   $0x26
  jmp alltraps
80105cb1:	e9 f4 f9 ff ff       	jmp    801056aa <alltraps>

80105cb6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105cb6:	6a 00                	push   $0x0
  pushl $39
80105cb8:	6a 27                	push   $0x27
  jmp alltraps
80105cba:	e9 eb f9 ff ff       	jmp    801056aa <alltraps>

80105cbf <vector40>:
.globl vector40
vector40:
  pushl $0
80105cbf:	6a 00                	push   $0x0
  pushl $40
80105cc1:	6a 28                	push   $0x28
  jmp alltraps
80105cc3:	e9 e2 f9 ff ff       	jmp    801056aa <alltraps>

80105cc8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105cc8:	6a 00                	push   $0x0
  pushl $41
80105cca:	6a 29                	push   $0x29
  jmp alltraps
80105ccc:	e9 d9 f9 ff ff       	jmp    801056aa <alltraps>

80105cd1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105cd1:	6a 00                	push   $0x0
  pushl $42
80105cd3:	6a 2a                	push   $0x2a
  jmp alltraps
80105cd5:	e9 d0 f9 ff ff       	jmp    801056aa <alltraps>

80105cda <vector43>:
.globl vector43
vector43:
  pushl $0
80105cda:	6a 00                	push   $0x0
  pushl $43
80105cdc:	6a 2b                	push   $0x2b
  jmp alltraps
80105cde:	e9 c7 f9 ff ff       	jmp    801056aa <alltraps>

80105ce3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105ce3:	6a 00                	push   $0x0
  pushl $44
80105ce5:	6a 2c                	push   $0x2c
  jmp alltraps
80105ce7:	e9 be f9 ff ff       	jmp    801056aa <alltraps>

80105cec <vector45>:
.globl vector45
vector45:
  pushl $0
80105cec:	6a 00                	push   $0x0
  pushl $45
80105cee:	6a 2d                	push   $0x2d
  jmp alltraps
80105cf0:	e9 b5 f9 ff ff       	jmp    801056aa <alltraps>

80105cf5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105cf5:	6a 00                	push   $0x0
  pushl $46
80105cf7:	6a 2e                	push   $0x2e
  jmp alltraps
80105cf9:	e9 ac f9 ff ff       	jmp    801056aa <alltraps>

80105cfe <vector47>:
.globl vector47
vector47:
  pushl $0
80105cfe:	6a 00                	push   $0x0
  pushl $47
80105d00:	6a 2f                	push   $0x2f
  jmp alltraps
80105d02:	e9 a3 f9 ff ff       	jmp    801056aa <alltraps>

80105d07 <vector48>:
.globl vector48
vector48:
  pushl $0
80105d07:	6a 00                	push   $0x0
  pushl $48
80105d09:	6a 30                	push   $0x30
  jmp alltraps
80105d0b:	e9 9a f9 ff ff       	jmp    801056aa <alltraps>

80105d10 <vector49>:
.globl vector49
vector49:
  pushl $0
80105d10:	6a 00                	push   $0x0
  pushl $49
80105d12:	6a 31                	push   $0x31
  jmp alltraps
80105d14:	e9 91 f9 ff ff       	jmp    801056aa <alltraps>

80105d19 <vector50>:
.globl vector50
vector50:
  pushl $0
80105d19:	6a 00                	push   $0x0
  pushl $50
80105d1b:	6a 32                	push   $0x32
  jmp alltraps
80105d1d:	e9 88 f9 ff ff       	jmp    801056aa <alltraps>

80105d22 <vector51>:
.globl vector51
vector51:
  pushl $0
80105d22:	6a 00                	push   $0x0
  pushl $51
80105d24:	6a 33                	push   $0x33
  jmp alltraps
80105d26:	e9 7f f9 ff ff       	jmp    801056aa <alltraps>

80105d2b <vector52>:
.globl vector52
vector52:
  pushl $0
80105d2b:	6a 00                	push   $0x0
  pushl $52
80105d2d:	6a 34                	push   $0x34
  jmp alltraps
80105d2f:	e9 76 f9 ff ff       	jmp    801056aa <alltraps>

80105d34 <vector53>:
.globl vector53
vector53:
  pushl $0
80105d34:	6a 00                	push   $0x0
  pushl $53
80105d36:	6a 35                	push   $0x35
  jmp alltraps
80105d38:	e9 6d f9 ff ff       	jmp    801056aa <alltraps>

80105d3d <vector54>:
.globl vector54
vector54:
  pushl $0
80105d3d:	6a 00                	push   $0x0
  pushl $54
80105d3f:	6a 36                	push   $0x36
  jmp alltraps
80105d41:	e9 64 f9 ff ff       	jmp    801056aa <alltraps>

80105d46 <vector55>:
.globl vector55
vector55:
  pushl $0
80105d46:	6a 00                	push   $0x0
  pushl $55
80105d48:	6a 37                	push   $0x37
  jmp alltraps
80105d4a:	e9 5b f9 ff ff       	jmp    801056aa <alltraps>

80105d4f <vector56>:
.globl vector56
vector56:
  pushl $0
80105d4f:	6a 00                	push   $0x0
  pushl $56
80105d51:	6a 38                	push   $0x38
  jmp alltraps
80105d53:	e9 52 f9 ff ff       	jmp    801056aa <alltraps>

80105d58 <vector57>:
.globl vector57
vector57:
  pushl $0
80105d58:	6a 00                	push   $0x0
  pushl $57
80105d5a:	6a 39                	push   $0x39
  jmp alltraps
80105d5c:	e9 49 f9 ff ff       	jmp    801056aa <alltraps>

80105d61 <vector58>:
.globl vector58
vector58:
  pushl $0
80105d61:	6a 00                	push   $0x0
  pushl $58
80105d63:	6a 3a                	push   $0x3a
  jmp alltraps
80105d65:	e9 40 f9 ff ff       	jmp    801056aa <alltraps>

80105d6a <vector59>:
.globl vector59
vector59:
  pushl $0
80105d6a:	6a 00                	push   $0x0
  pushl $59
80105d6c:	6a 3b                	push   $0x3b
  jmp alltraps
80105d6e:	e9 37 f9 ff ff       	jmp    801056aa <alltraps>

80105d73 <vector60>:
.globl vector60
vector60:
  pushl $0
80105d73:	6a 00                	push   $0x0
  pushl $60
80105d75:	6a 3c                	push   $0x3c
  jmp alltraps
80105d77:	e9 2e f9 ff ff       	jmp    801056aa <alltraps>

80105d7c <vector61>:
.globl vector61
vector61:
  pushl $0
80105d7c:	6a 00                	push   $0x0
  pushl $61
80105d7e:	6a 3d                	push   $0x3d
  jmp alltraps
80105d80:	e9 25 f9 ff ff       	jmp    801056aa <alltraps>

80105d85 <vector62>:
.globl vector62
vector62:
  pushl $0
80105d85:	6a 00                	push   $0x0
  pushl $62
80105d87:	6a 3e                	push   $0x3e
  jmp alltraps
80105d89:	e9 1c f9 ff ff       	jmp    801056aa <alltraps>

80105d8e <vector63>:
.globl vector63
vector63:
  pushl $0
80105d8e:	6a 00                	push   $0x0
  pushl $63
80105d90:	6a 3f                	push   $0x3f
  jmp alltraps
80105d92:	e9 13 f9 ff ff       	jmp    801056aa <alltraps>

80105d97 <vector64>:
.globl vector64
vector64:
  pushl $0
80105d97:	6a 00                	push   $0x0
  pushl $64
80105d99:	6a 40                	push   $0x40
  jmp alltraps
80105d9b:	e9 0a f9 ff ff       	jmp    801056aa <alltraps>

80105da0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105da0:	6a 00                	push   $0x0
  pushl $65
80105da2:	6a 41                	push   $0x41
  jmp alltraps
80105da4:	e9 01 f9 ff ff       	jmp    801056aa <alltraps>

80105da9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105da9:	6a 00                	push   $0x0
  pushl $66
80105dab:	6a 42                	push   $0x42
  jmp alltraps
80105dad:	e9 f8 f8 ff ff       	jmp    801056aa <alltraps>

80105db2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105db2:	6a 00                	push   $0x0
  pushl $67
80105db4:	6a 43                	push   $0x43
  jmp alltraps
80105db6:	e9 ef f8 ff ff       	jmp    801056aa <alltraps>

80105dbb <vector68>:
.globl vector68
vector68:
  pushl $0
80105dbb:	6a 00                	push   $0x0
  pushl $68
80105dbd:	6a 44                	push   $0x44
  jmp alltraps
80105dbf:	e9 e6 f8 ff ff       	jmp    801056aa <alltraps>

80105dc4 <vector69>:
.globl vector69
vector69:
  pushl $0
80105dc4:	6a 00                	push   $0x0
  pushl $69
80105dc6:	6a 45                	push   $0x45
  jmp alltraps
80105dc8:	e9 dd f8 ff ff       	jmp    801056aa <alltraps>

80105dcd <vector70>:
.globl vector70
vector70:
  pushl $0
80105dcd:	6a 00                	push   $0x0
  pushl $70
80105dcf:	6a 46                	push   $0x46
  jmp alltraps
80105dd1:	e9 d4 f8 ff ff       	jmp    801056aa <alltraps>

80105dd6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105dd6:	6a 00                	push   $0x0
  pushl $71
80105dd8:	6a 47                	push   $0x47
  jmp alltraps
80105dda:	e9 cb f8 ff ff       	jmp    801056aa <alltraps>

80105ddf <vector72>:
.globl vector72
vector72:
  pushl $0
80105ddf:	6a 00                	push   $0x0
  pushl $72
80105de1:	6a 48                	push   $0x48
  jmp alltraps
80105de3:	e9 c2 f8 ff ff       	jmp    801056aa <alltraps>

80105de8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105de8:	6a 00                	push   $0x0
  pushl $73
80105dea:	6a 49                	push   $0x49
  jmp alltraps
80105dec:	e9 b9 f8 ff ff       	jmp    801056aa <alltraps>

80105df1 <vector74>:
.globl vector74
vector74:
  pushl $0
80105df1:	6a 00                	push   $0x0
  pushl $74
80105df3:	6a 4a                	push   $0x4a
  jmp alltraps
80105df5:	e9 b0 f8 ff ff       	jmp    801056aa <alltraps>

80105dfa <vector75>:
.globl vector75
vector75:
  pushl $0
80105dfa:	6a 00                	push   $0x0
  pushl $75
80105dfc:	6a 4b                	push   $0x4b
  jmp alltraps
80105dfe:	e9 a7 f8 ff ff       	jmp    801056aa <alltraps>

80105e03 <vector76>:
.globl vector76
vector76:
  pushl $0
80105e03:	6a 00                	push   $0x0
  pushl $76
80105e05:	6a 4c                	push   $0x4c
  jmp alltraps
80105e07:	e9 9e f8 ff ff       	jmp    801056aa <alltraps>

80105e0c <vector77>:
.globl vector77
vector77:
  pushl $0
80105e0c:	6a 00                	push   $0x0
  pushl $77
80105e0e:	6a 4d                	push   $0x4d
  jmp alltraps
80105e10:	e9 95 f8 ff ff       	jmp    801056aa <alltraps>

80105e15 <vector78>:
.globl vector78
vector78:
  pushl $0
80105e15:	6a 00                	push   $0x0
  pushl $78
80105e17:	6a 4e                	push   $0x4e
  jmp alltraps
80105e19:	e9 8c f8 ff ff       	jmp    801056aa <alltraps>

80105e1e <vector79>:
.globl vector79
vector79:
  pushl $0
80105e1e:	6a 00                	push   $0x0
  pushl $79
80105e20:	6a 4f                	push   $0x4f
  jmp alltraps
80105e22:	e9 83 f8 ff ff       	jmp    801056aa <alltraps>

80105e27 <vector80>:
.globl vector80
vector80:
  pushl $0
80105e27:	6a 00                	push   $0x0
  pushl $80
80105e29:	6a 50                	push   $0x50
  jmp alltraps
80105e2b:	e9 7a f8 ff ff       	jmp    801056aa <alltraps>

80105e30 <vector81>:
.globl vector81
vector81:
  pushl $0
80105e30:	6a 00                	push   $0x0
  pushl $81
80105e32:	6a 51                	push   $0x51
  jmp alltraps
80105e34:	e9 71 f8 ff ff       	jmp    801056aa <alltraps>

80105e39 <vector82>:
.globl vector82
vector82:
  pushl $0
80105e39:	6a 00                	push   $0x0
  pushl $82
80105e3b:	6a 52                	push   $0x52
  jmp alltraps
80105e3d:	e9 68 f8 ff ff       	jmp    801056aa <alltraps>

80105e42 <vector83>:
.globl vector83
vector83:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $83
80105e44:	6a 53                	push   $0x53
  jmp alltraps
80105e46:	e9 5f f8 ff ff       	jmp    801056aa <alltraps>

80105e4b <vector84>:
.globl vector84
vector84:
  pushl $0
80105e4b:	6a 00                	push   $0x0
  pushl $84
80105e4d:	6a 54                	push   $0x54
  jmp alltraps
80105e4f:	e9 56 f8 ff ff       	jmp    801056aa <alltraps>

80105e54 <vector85>:
.globl vector85
vector85:
  pushl $0
80105e54:	6a 00                	push   $0x0
  pushl $85
80105e56:	6a 55                	push   $0x55
  jmp alltraps
80105e58:	e9 4d f8 ff ff       	jmp    801056aa <alltraps>

80105e5d <vector86>:
.globl vector86
vector86:
  pushl $0
80105e5d:	6a 00                	push   $0x0
  pushl $86
80105e5f:	6a 56                	push   $0x56
  jmp alltraps
80105e61:	e9 44 f8 ff ff       	jmp    801056aa <alltraps>

80105e66 <vector87>:
.globl vector87
vector87:
  pushl $0
80105e66:	6a 00                	push   $0x0
  pushl $87
80105e68:	6a 57                	push   $0x57
  jmp alltraps
80105e6a:	e9 3b f8 ff ff       	jmp    801056aa <alltraps>

80105e6f <vector88>:
.globl vector88
vector88:
  pushl $0
80105e6f:	6a 00                	push   $0x0
  pushl $88
80105e71:	6a 58                	push   $0x58
  jmp alltraps
80105e73:	e9 32 f8 ff ff       	jmp    801056aa <alltraps>

80105e78 <vector89>:
.globl vector89
vector89:
  pushl $0
80105e78:	6a 00                	push   $0x0
  pushl $89
80105e7a:	6a 59                	push   $0x59
  jmp alltraps
80105e7c:	e9 29 f8 ff ff       	jmp    801056aa <alltraps>

80105e81 <vector90>:
.globl vector90
vector90:
  pushl $0
80105e81:	6a 00                	push   $0x0
  pushl $90
80105e83:	6a 5a                	push   $0x5a
  jmp alltraps
80105e85:	e9 20 f8 ff ff       	jmp    801056aa <alltraps>

80105e8a <vector91>:
.globl vector91
vector91:
  pushl $0
80105e8a:	6a 00                	push   $0x0
  pushl $91
80105e8c:	6a 5b                	push   $0x5b
  jmp alltraps
80105e8e:	e9 17 f8 ff ff       	jmp    801056aa <alltraps>

80105e93 <vector92>:
.globl vector92
vector92:
  pushl $0
80105e93:	6a 00                	push   $0x0
  pushl $92
80105e95:	6a 5c                	push   $0x5c
  jmp alltraps
80105e97:	e9 0e f8 ff ff       	jmp    801056aa <alltraps>

80105e9c <vector93>:
.globl vector93
vector93:
  pushl $0
80105e9c:	6a 00                	push   $0x0
  pushl $93
80105e9e:	6a 5d                	push   $0x5d
  jmp alltraps
80105ea0:	e9 05 f8 ff ff       	jmp    801056aa <alltraps>

80105ea5 <vector94>:
.globl vector94
vector94:
  pushl $0
80105ea5:	6a 00                	push   $0x0
  pushl $94
80105ea7:	6a 5e                	push   $0x5e
  jmp alltraps
80105ea9:	e9 fc f7 ff ff       	jmp    801056aa <alltraps>

80105eae <vector95>:
.globl vector95
vector95:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $95
80105eb0:	6a 5f                	push   $0x5f
  jmp alltraps
80105eb2:	e9 f3 f7 ff ff       	jmp    801056aa <alltraps>

80105eb7 <vector96>:
.globl vector96
vector96:
  pushl $0
80105eb7:	6a 00                	push   $0x0
  pushl $96
80105eb9:	6a 60                	push   $0x60
  jmp alltraps
80105ebb:	e9 ea f7 ff ff       	jmp    801056aa <alltraps>

80105ec0 <vector97>:
.globl vector97
vector97:
  pushl $0
80105ec0:	6a 00                	push   $0x0
  pushl $97
80105ec2:	6a 61                	push   $0x61
  jmp alltraps
80105ec4:	e9 e1 f7 ff ff       	jmp    801056aa <alltraps>

80105ec9 <vector98>:
.globl vector98
vector98:
  pushl $0
80105ec9:	6a 00                	push   $0x0
  pushl $98
80105ecb:	6a 62                	push   $0x62
  jmp alltraps
80105ecd:	e9 d8 f7 ff ff       	jmp    801056aa <alltraps>

80105ed2 <vector99>:
.globl vector99
vector99:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $99
80105ed4:	6a 63                	push   $0x63
  jmp alltraps
80105ed6:	e9 cf f7 ff ff       	jmp    801056aa <alltraps>

80105edb <vector100>:
.globl vector100
vector100:
  pushl $0
80105edb:	6a 00                	push   $0x0
  pushl $100
80105edd:	6a 64                	push   $0x64
  jmp alltraps
80105edf:	e9 c6 f7 ff ff       	jmp    801056aa <alltraps>

80105ee4 <vector101>:
.globl vector101
vector101:
  pushl $0
80105ee4:	6a 00                	push   $0x0
  pushl $101
80105ee6:	6a 65                	push   $0x65
  jmp alltraps
80105ee8:	e9 bd f7 ff ff       	jmp    801056aa <alltraps>

80105eed <vector102>:
.globl vector102
vector102:
  pushl $0
80105eed:	6a 00                	push   $0x0
  pushl $102
80105eef:	6a 66                	push   $0x66
  jmp alltraps
80105ef1:	e9 b4 f7 ff ff       	jmp    801056aa <alltraps>

80105ef6 <vector103>:
.globl vector103
vector103:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $103
80105ef8:	6a 67                	push   $0x67
  jmp alltraps
80105efa:	e9 ab f7 ff ff       	jmp    801056aa <alltraps>

80105eff <vector104>:
.globl vector104
vector104:
  pushl $0
80105eff:	6a 00                	push   $0x0
  pushl $104
80105f01:	6a 68                	push   $0x68
  jmp alltraps
80105f03:	e9 a2 f7 ff ff       	jmp    801056aa <alltraps>

80105f08 <vector105>:
.globl vector105
vector105:
  pushl $0
80105f08:	6a 00                	push   $0x0
  pushl $105
80105f0a:	6a 69                	push   $0x69
  jmp alltraps
80105f0c:	e9 99 f7 ff ff       	jmp    801056aa <alltraps>

80105f11 <vector106>:
.globl vector106
vector106:
  pushl $0
80105f11:	6a 00                	push   $0x0
  pushl $106
80105f13:	6a 6a                	push   $0x6a
  jmp alltraps
80105f15:	e9 90 f7 ff ff       	jmp    801056aa <alltraps>

80105f1a <vector107>:
.globl vector107
vector107:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $107
80105f1c:	6a 6b                	push   $0x6b
  jmp alltraps
80105f1e:	e9 87 f7 ff ff       	jmp    801056aa <alltraps>

80105f23 <vector108>:
.globl vector108
vector108:
  pushl $0
80105f23:	6a 00                	push   $0x0
  pushl $108
80105f25:	6a 6c                	push   $0x6c
  jmp alltraps
80105f27:	e9 7e f7 ff ff       	jmp    801056aa <alltraps>

80105f2c <vector109>:
.globl vector109
vector109:
  pushl $0
80105f2c:	6a 00                	push   $0x0
  pushl $109
80105f2e:	6a 6d                	push   $0x6d
  jmp alltraps
80105f30:	e9 75 f7 ff ff       	jmp    801056aa <alltraps>

80105f35 <vector110>:
.globl vector110
vector110:
  pushl $0
80105f35:	6a 00                	push   $0x0
  pushl $110
80105f37:	6a 6e                	push   $0x6e
  jmp alltraps
80105f39:	e9 6c f7 ff ff       	jmp    801056aa <alltraps>

80105f3e <vector111>:
.globl vector111
vector111:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $111
80105f40:	6a 6f                	push   $0x6f
  jmp alltraps
80105f42:	e9 63 f7 ff ff       	jmp    801056aa <alltraps>

80105f47 <vector112>:
.globl vector112
vector112:
  pushl $0
80105f47:	6a 00                	push   $0x0
  pushl $112
80105f49:	6a 70                	push   $0x70
  jmp alltraps
80105f4b:	e9 5a f7 ff ff       	jmp    801056aa <alltraps>

80105f50 <vector113>:
.globl vector113
vector113:
  pushl $0
80105f50:	6a 00                	push   $0x0
  pushl $113
80105f52:	6a 71                	push   $0x71
  jmp alltraps
80105f54:	e9 51 f7 ff ff       	jmp    801056aa <alltraps>

80105f59 <vector114>:
.globl vector114
vector114:
  pushl $0
80105f59:	6a 00                	push   $0x0
  pushl $114
80105f5b:	6a 72                	push   $0x72
  jmp alltraps
80105f5d:	e9 48 f7 ff ff       	jmp    801056aa <alltraps>

80105f62 <vector115>:
.globl vector115
vector115:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $115
80105f64:	6a 73                	push   $0x73
  jmp alltraps
80105f66:	e9 3f f7 ff ff       	jmp    801056aa <alltraps>

80105f6b <vector116>:
.globl vector116
vector116:
  pushl $0
80105f6b:	6a 00                	push   $0x0
  pushl $116
80105f6d:	6a 74                	push   $0x74
  jmp alltraps
80105f6f:	e9 36 f7 ff ff       	jmp    801056aa <alltraps>

80105f74 <vector117>:
.globl vector117
vector117:
  pushl $0
80105f74:	6a 00                	push   $0x0
  pushl $117
80105f76:	6a 75                	push   $0x75
  jmp alltraps
80105f78:	e9 2d f7 ff ff       	jmp    801056aa <alltraps>

80105f7d <vector118>:
.globl vector118
vector118:
  pushl $0
80105f7d:	6a 00                	push   $0x0
  pushl $118
80105f7f:	6a 76                	push   $0x76
  jmp alltraps
80105f81:	e9 24 f7 ff ff       	jmp    801056aa <alltraps>

80105f86 <vector119>:
.globl vector119
vector119:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $119
80105f88:	6a 77                	push   $0x77
  jmp alltraps
80105f8a:	e9 1b f7 ff ff       	jmp    801056aa <alltraps>

80105f8f <vector120>:
.globl vector120
vector120:
  pushl $0
80105f8f:	6a 00                	push   $0x0
  pushl $120
80105f91:	6a 78                	push   $0x78
  jmp alltraps
80105f93:	e9 12 f7 ff ff       	jmp    801056aa <alltraps>

80105f98 <vector121>:
.globl vector121
vector121:
  pushl $0
80105f98:	6a 00                	push   $0x0
  pushl $121
80105f9a:	6a 79                	push   $0x79
  jmp alltraps
80105f9c:	e9 09 f7 ff ff       	jmp    801056aa <alltraps>

80105fa1 <vector122>:
.globl vector122
vector122:
  pushl $0
80105fa1:	6a 00                	push   $0x0
  pushl $122
80105fa3:	6a 7a                	push   $0x7a
  jmp alltraps
80105fa5:	e9 00 f7 ff ff       	jmp    801056aa <alltraps>

80105faa <vector123>:
.globl vector123
vector123:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $123
80105fac:	6a 7b                	push   $0x7b
  jmp alltraps
80105fae:	e9 f7 f6 ff ff       	jmp    801056aa <alltraps>

80105fb3 <vector124>:
.globl vector124
vector124:
  pushl $0
80105fb3:	6a 00                	push   $0x0
  pushl $124
80105fb5:	6a 7c                	push   $0x7c
  jmp alltraps
80105fb7:	e9 ee f6 ff ff       	jmp    801056aa <alltraps>

80105fbc <vector125>:
.globl vector125
vector125:
  pushl $0
80105fbc:	6a 00                	push   $0x0
  pushl $125
80105fbe:	6a 7d                	push   $0x7d
  jmp alltraps
80105fc0:	e9 e5 f6 ff ff       	jmp    801056aa <alltraps>

80105fc5 <vector126>:
.globl vector126
vector126:
  pushl $0
80105fc5:	6a 00                	push   $0x0
  pushl $126
80105fc7:	6a 7e                	push   $0x7e
  jmp alltraps
80105fc9:	e9 dc f6 ff ff       	jmp    801056aa <alltraps>

80105fce <vector127>:
.globl vector127
vector127:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $127
80105fd0:	6a 7f                	push   $0x7f
  jmp alltraps
80105fd2:	e9 d3 f6 ff ff       	jmp    801056aa <alltraps>

80105fd7 <vector128>:
.globl vector128
vector128:
  pushl $0
80105fd7:	6a 00                	push   $0x0
  pushl $128
80105fd9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105fde:	e9 c7 f6 ff ff       	jmp    801056aa <alltraps>

80105fe3 <vector129>:
.globl vector129
vector129:
  pushl $0
80105fe3:	6a 00                	push   $0x0
  pushl $129
80105fe5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105fea:	e9 bb f6 ff ff       	jmp    801056aa <alltraps>

80105fef <vector130>:
.globl vector130
vector130:
  pushl $0
80105fef:	6a 00                	push   $0x0
  pushl $130
80105ff1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105ff6:	e9 af f6 ff ff       	jmp    801056aa <alltraps>

80105ffb <vector131>:
.globl vector131
vector131:
  pushl $0
80105ffb:	6a 00                	push   $0x0
  pushl $131
80105ffd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106002:	e9 a3 f6 ff ff       	jmp    801056aa <alltraps>

80106007 <vector132>:
.globl vector132
vector132:
  pushl $0
80106007:	6a 00                	push   $0x0
  pushl $132
80106009:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010600e:	e9 97 f6 ff ff       	jmp    801056aa <alltraps>

80106013 <vector133>:
.globl vector133
vector133:
  pushl $0
80106013:	6a 00                	push   $0x0
  pushl $133
80106015:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010601a:	e9 8b f6 ff ff       	jmp    801056aa <alltraps>

8010601f <vector134>:
.globl vector134
vector134:
  pushl $0
8010601f:	6a 00                	push   $0x0
  pushl $134
80106021:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106026:	e9 7f f6 ff ff       	jmp    801056aa <alltraps>

8010602b <vector135>:
.globl vector135
vector135:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $135
8010602d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106032:	e9 73 f6 ff ff       	jmp    801056aa <alltraps>

80106037 <vector136>:
.globl vector136
vector136:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $136
80106039:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010603e:	e9 67 f6 ff ff       	jmp    801056aa <alltraps>

80106043 <vector137>:
.globl vector137
vector137:
  pushl $0
80106043:	6a 00                	push   $0x0
  pushl $137
80106045:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010604a:	e9 5b f6 ff ff       	jmp    801056aa <alltraps>

8010604f <vector138>:
.globl vector138
vector138:
  pushl $0
8010604f:	6a 00                	push   $0x0
  pushl $138
80106051:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106056:	e9 4f f6 ff ff       	jmp    801056aa <alltraps>

8010605b <vector139>:
.globl vector139
vector139:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $139
8010605d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106062:	e9 43 f6 ff ff       	jmp    801056aa <alltraps>

80106067 <vector140>:
.globl vector140
vector140:
  pushl $0
80106067:	6a 00                	push   $0x0
  pushl $140
80106069:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010606e:	e9 37 f6 ff ff       	jmp    801056aa <alltraps>

80106073 <vector141>:
.globl vector141
vector141:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $141
80106075:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010607a:	e9 2b f6 ff ff       	jmp    801056aa <alltraps>

8010607f <vector142>:
.globl vector142
vector142:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $142
80106081:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106086:	e9 1f f6 ff ff       	jmp    801056aa <alltraps>

8010608b <vector143>:
.globl vector143
vector143:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $143
8010608d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106092:	e9 13 f6 ff ff       	jmp    801056aa <alltraps>

80106097 <vector144>:
.globl vector144
vector144:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $144
80106099:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010609e:	e9 07 f6 ff ff       	jmp    801056aa <alltraps>

801060a3 <vector145>:
.globl vector145
vector145:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $145
801060a5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801060aa:	e9 fb f5 ff ff       	jmp    801056aa <alltraps>

801060af <vector146>:
.globl vector146
vector146:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $146
801060b1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801060b6:	e9 ef f5 ff ff       	jmp    801056aa <alltraps>

801060bb <vector147>:
.globl vector147
vector147:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $147
801060bd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801060c2:	e9 e3 f5 ff ff       	jmp    801056aa <alltraps>

801060c7 <vector148>:
.globl vector148
vector148:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $148
801060c9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801060ce:	e9 d7 f5 ff ff       	jmp    801056aa <alltraps>

801060d3 <vector149>:
.globl vector149
vector149:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $149
801060d5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801060da:	e9 cb f5 ff ff       	jmp    801056aa <alltraps>

801060df <vector150>:
.globl vector150
vector150:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $150
801060e1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801060e6:	e9 bf f5 ff ff       	jmp    801056aa <alltraps>

801060eb <vector151>:
.globl vector151
vector151:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $151
801060ed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801060f2:	e9 b3 f5 ff ff       	jmp    801056aa <alltraps>

801060f7 <vector152>:
.globl vector152
vector152:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $152
801060f9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801060fe:	e9 a7 f5 ff ff       	jmp    801056aa <alltraps>

80106103 <vector153>:
.globl vector153
vector153:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $153
80106105:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010610a:	e9 9b f5 ff ff       	jmp    801056aa <alltraps>

8010610f <vector154>:
.globl vector154
vector154:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $154
80106111:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106116:	e9 8f f5 ff ff       	jmp    801056aa <alltraps>

8010611b <vector155>:
.globl vector155
vector155:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $155
8010611d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106122:	e9 83 f5 ff ff       	jmp    801056aa <alltraps>

80106127 <vector156>:
.globl vector156
vector156:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $156
80106129:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010612e:	e9 77 f5 ff ff       	jmp    801056aa <alltraps>

80106133 <vector157>:
.globl vector157
vector157:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $157
80106135:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010613a:	e9 6b f5 ff ff       	jmp    801056aa <alltraps>

8010613f <vector158>:
.globl vector158
vector158:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $158
80106141:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106146:	e9 5f f5 ff ff       	jmp    801056aa <alltraps>

8010614b <vector159>:
.globl vector159
vector159:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $159
8010614d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106152:	e9 53 f5 ff ff       	jmp    801056aa <alltraps>

80106157 <vector160>:
.globl vector160
vector160:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $160
80106159:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010615e:	e9 47 f5 ff ff       	jmp    801056aa <alltraps>

80106163 <vector161>:
.globl vector161
vector161:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $161
80106165:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010616a:	e9 3b f5 ff ff       	jmp    801056aa <alltraps>

8010616f <vector162>:
.globl vector162
vector162:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $162
80106171:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106176:	e9 2f f5 ff ff       	jmp    801056aa <alltraps>

8010617b <vector163>:
.globl vector163
vector163:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $163
8010617d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106182:	e9 23 f5 ff ff       	jmp    801056aa <alltraps>

80106187 <vector164>:
.globl vector164
vector164:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $164
80106189:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010618e:	e9 17 f5 ff ff       	jmp    801056aa <alltraps>

80106193 <vector165>:
.globl vector165
vector165:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $165
80106195:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010619a:	e9 0b f5 ff ff       	jmp    801056aa <alltraps>

8010619f <vector166>:
.globl vector166
vector166:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $166
801061a1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801061a6:	e9 ff f4 ff ff       	jmp    801056aa <alltraps>

801061ab <vector167>:
.globl vector167
vector167:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $167
801061ad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801061b2:	e9 f3 f4 ff ff       	jmp    801056aa <alltraps>

801061b7 <vector168>:
.globl vector168
vector168:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $168
801061b9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801061be:	e9 e7 f4 ff ff       	jmp    801056aa <alltraps>

801061c3 <vector169>:
.globl vector169
vector169:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $169
801061c5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801061ca:	e9 db f4 ff ff       	jmp    801056aa <alltraps>

801061cf <vector170>:
.globl vector170
vector170:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $170
801061d1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801061d6:	e9 cf f4 ff ff       	jmp    801056aa <alltraps>

801061db <vector171>:
.globl vector171
vector171:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $171
801061dd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801061e2:	e9 c3 f4 ff ff       	jmp    801056aa <alltraps>

801061e7 <vector172>:
.globl vector172
vector172:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $172
801061e9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801061ee:	e9 b7 f4 ff ff       	jmp    801056aa <alltraps>

801061f3 <vector173>:
.globl vector173
vector173:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $173
801061f5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801061fa:	e9 ab f4 ff ff       	jmp    801056aa <alltraps>

801061ff <vector174>:
.globl vector174
vector174:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $174
80106201:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106206:	e9 9f f4 ff ff       	jmp    801056aa <alltraps>

8010620b <vector175>:
.globl vector175
vector175:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $175
8010620d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106212:	e9 93 f4 ff ff       	jmp    801056aa <alltraps>

80106217 <vector176>:
.globl vector176
vector176:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $176
80106219:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010621e:	e9 87 f4 ff ff       	jmp    801056aa <alltraps>

80106223 <vector177>:
.globl vector177
vector177:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $177
80106225:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010622a:	e9 7b f4 ff ff       	jmp    801056aa <alltraps>

8010622f <vector178>:
.globl vector178
vector178:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $178
80106231:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106236:	e9 6f f4 ff ff       	jmp    801056aa <alltraps>

8010623b <vector179>:
.globl vector179
vector179:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $179
8010623d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106242:	e9 63 f4 ff ff       	jmp    801056aa <alltraps>

80106247 <vector180>:
.globl vector180
vector180:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $180
80106249:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010624e:	e9 57 f4 ff ff       	jmp    801056aa <alltraps>

80106253 <vector181>:
.globl vector181
vector181:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $181
80106255:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010625a:	e9 4b f4 ff ff       	jmp    801056aa <alltraps>

8010625f <vector182>:
.globl vector182
vector182:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $182
80106261:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106266:	e9 3f f4 ff ff       	jmp    801056aa <alltraps>

8010626b <vector183>:
.globl vector183
vector183:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $183
8010626d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106272:	e9 33 f4 ff ff       	jmp    801056aa <alltraps>

80106277 <vector184>:
.globl vector184
vector184:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $184
80106279:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010627e:	e9 27 f4 ff ff       	jmp    801056aa <alltraps>

80106283 <vector185>:
.globl vector185
vector185:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $185
80106285:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010628a:	e9 1b f4 ff ff       	jmp    801056aa <alltraps>

8010628f <vector186>:
.globl vector186
vector186:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $186
80106291:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106296:	e9 0f f4 ff ff       	jmp    801056aa <alltraps>

8010629b <vector187>:
.globl vector187
vector187:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $187
8010629d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801062a2:	e9 03 f4 ff ff       	jmp    801056aa <alltraps>

801062a7 <vector188>:
.globl vector188
vector188:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $188
801062a9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801062ae:	e9 f7 f3 ff ff       	jmp    801056aa <alltraps>

801062b3 <vector189>:
.globl vector189
vector189:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $189
801062b5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801062ba:	e9 eb f3 ff ff       	jmp    801056aa <alltraps>

801062bf <vector190>:
.globl vector190
vector190:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $190
801062c1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801062c6:	e9 df f3 ff ff       	jmp    801056aa <alltraps>

801062cb <vector191>:
.globl vector191
vector191:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $191
801062cd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801062d2:	e9 d3 f3 ff ff       	jmp    801056aa <alltraps>

801062d7 <vector192>:
.globl vector192
vector192:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $192
801062d9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801062de:	e9 c7 f3 ff ff       	jmp    801056aa <alltraps>

801062e3 <vector193>:
.globl vector193
vector193:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $193
801062e5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801062ea:	e9 bb f3 ff ff       	jmp    801056aa <alltraps>

801062ef <vector194>:
.globl vector194
vector194:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $194
801062f1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801062f6:	e9 af f3 ff ff       	jmp    801056aa <alltraps>

801062fb <vector195>:
.globl vector195
vector195:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $195
801062fd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106302:	e9 a3 f3 ff ff       	jmp    801056aa <alltraps>

80106307 <vector196>:
.globl vector196
vector196:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $196
80106309:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010630e:	e9 97 f3 ff ff       	jmp    801056aa <alltraps>

80106313 <vector197>:
.globl vector197
vector197:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $197
80106315:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010631a:	e9 8b f3 ff ff       	jmp    801056aa <alltraps>

8010631f <vector198>:
.globl vector198
vector198:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $198
80106321:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106326:	e9 7f f3 ff ff       	jmp    801056aa <alltraps>

8010632b <vector199>:
.globl vector199
vector199:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $199
8010632d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106332:	e9 73 f3 ff ff       	jmp    801056aa <alltraps>

80106337 <vector200>:
.globl vector200
vector200:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $200
80106339:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010633e:	e9 67 f3 ff ff       	jmp    801056aa <alltraps>

80106343 <vector201>:
.globl vector201
vector201:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $201
80106345:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010634a:	e9 5b f3 ff ff       	jmp    801056aa <alltraps>

8010634f <vector202>:
.globl vector202
vector202:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $202
80106351:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106356:	e9 4f f3 ff ff       	jmp    801056aa <alltraps>

8010635b <vector203>:
.globl vector203
vector203:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $203
8010635d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106362:	e9 43 f3 ff ff       	jmp    801056aa <alltraps>

80106367 <vector204>:
.globl vector204
vector204:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $204
80106369:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010636e:	e9 37 f3 ff ff       	jmp    801056aa <alltraps>

80106373 <vector205>:
.globl vector205
vector205:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $205
80106375:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010637a:	e9 2b f3 ff ff       	jmp    801056aa <alltraps>

8010637f <vector206>:
.globl vector206
vector206:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $206
80106381:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106386:	e9 1f f3 ff ff       	jmp    801056aa <alltraps>

8010638b <vector207>:
.globl vector207
vector207:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $207
8010638d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106392:	e9 13 f3 ff ff       	jmp    801056aa <alltraps>

80106397 <vector208>:
.globl vector208
vector208:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $208
80106399:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010639e:	e9 07 f3 ff ff       	jmp    801056aa <alltraps>

801063a3 <vector209>:
.globl vector209
vector209:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $209
801063a5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801063aa:	e9 fb f2 ff ff       	jmp    801056aa <alltraps>

801063af <vector210>:
.globl vector210
vector210:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $210
801063b1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801063b6:	e9 ef f2 ff ff       	jmp    801056aa <alltraps>

801063bb <vector211>:
.globl vector211
vector211:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $211
801063bd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801063c2:	e9 e3 f2 ff ff       	jmp    801056aa <alltraps>

801063c7 <vector212>:
.globl vector212
vector212:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $212
801063c9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801063ce:	e9 d7 f2 ff ff       	jmp    801056aa <alltraps>

801063d3 <vector213>:
.globl vector213
vector213:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $213
801063d5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801063da:	e9 cb f2 ff ff       	jmp    801056aa <alltraps>

801063df <vector214>:
.globl vector214
vector214:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $214
801063e1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801063e6:	e9 bf f2 ff ff       	jmp    801056aa <alltraps>

801063eb <vector215>:
.globl vector215
vector215:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $215
801063ed:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801063f2:	e9 b3 f2 ff ff       	jmp    801056aa <alltraps>

801063f7 <vector216>:
.globl vector216
vector216:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $216
801063f9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801063fe:	e9 a7 f2 ff ff       	jmp    801056aa <alltraps>

80106403 <vector217>:
.globl vector217
vector217:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $217
80106405:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010640a:	e9 9b f2 ff ff       	jmp    801056aa <alltraps>

8010640f <vector218>:
.globl vector218
vector218:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $218
80106411:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106416:	e9 8f f2 ff ff       	jmp    801056aa <alltraps>

8010641b <vector219>:
.globl vector219
vector219:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $219
8010641d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106422:	e9 83 f2 ff ff       	jmp    801056aa <alltraps>

80106427 <vector220>:
.globl vector220
vector220:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $220
80106429:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010642e:	e9 77 f2 ff ff       	jmp    801056aa <alltraps>

80106433 <vector221>:
.globl vector221
vector221:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $221
80106435:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010643a:	e9 6b f2 ff ff       	jmp    801056aa <alltraps>

8010643f <vector222>:
.globl vector222
vector222:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $222
80106441:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106446:	e9 5f f2 ff ff       	jmp    801056aa <alltraps>

8010644b <vector223>:
.globl vector223
vector223:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $223
8010644d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106452:	e9 53 f2 ff ff       	jmp    801056aa <alltraps>

80106457 <vector224>:
.globl vector224
vector224:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $224
80106459:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010645e:	e9 47 f2 ff ff       	jmp    801056aa <alltraps>

80106463 <vector225>:
.globl vector225
vector225:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $225
80106465:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010646a:	e9 3b f2 ff ff       	jmp    801056aa <alltraps>

8010646f <vector226>:
.globl vector226
vector226:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $226
80106471:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106476:	e9 2f f2 ff ff       	jmp    801056aa <alltraps>

8010647b <vector227>:
.globl vector227
vector227:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $227
8010647d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106482:	e9 23 f2 ff ff       	jmp    801056aa <alltraps>

80106487 <vector228>:
.globl vector228
vector228:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $228
80106489:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010648e:	e9 17 f2 ff ff       	jmp    801056aa <alltraps>

80106493 <vector229>:
.globl vector229
vector229:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $229
80106495:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010649a:	e9 0b f2 ff ff       	jmp    801056aa <alltraps>

8010649f <vector230>:
.globl vector230
vector230:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $230
801064a1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801064a6:	e9 ff f1 ff ff       	jmp    801056aa <alltraps>

801064ab <vector231>:
.globl vector231
vector231:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $231
801064ad:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801064b2:	e9 f3 f1 ff ff       	jmp    801056aa <alltraps>

801064b7 <vector232>:
.globl vector232
vector232:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $232
801064b9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801064be:	e9 e7 f1 ff ff       	jmp    801056aa <alltraps>

801064c3 <vector233>:
.globl vector233
vector233:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $233
801064c5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801064ca:	e9 db f1 ff ff       	jmp    801056aa <alltraps>

801064cf <vector234>:
.globl vector234
vector234:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $234
801064d1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801064d6:	e9 cf f1 ff ff       	jmp    801056aa <alltraps>

801064db <vector235>:
.globl vector235
vector235:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $235
801064dd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801064e2:	e9 c3 f1 ff ff       	jmp    801056aa <alltraps>

801064e7 <vector236>:
.globl vector236
vector236:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $236
801064e9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801064ee:	e9 b7 f1 ff ff       	jmp    801056aa <alltraps>

801064f3 <vector237>:
.globl vector237
vector237:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $237
801064f5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801064fa:	e9 ab f1 ff ff       	jmp    801056aa <alltraps>

801064ff <vector238>:
.globl vector238
vector238:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $238
80106501:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106506:	e9 9f f1 ff ff       	jmp    801056aa <alltraps>

8010650b <vector239>:
.globl vector239
vector239:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $239
8010650d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106512:	e9 93 f1 ff ff       	jmp    801056aa <alltraps>

80106517 <vector240>:
.globl vector240
vector240:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $240
80106519:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010651e:	e9 87 f1 ff ff       	jmp    801056aa <alltraps>

80106523 <vector241>:
.globl vector241
vector241:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $241
80106525:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010652a:	e9 7b f1 ff ff       	jmp    801056aa <alltraps>

8010652f <vector242>:
.globl vector242
vector242:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $242
80106531:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106536:	e9 6f f1 ff ff       	jmp    801056aa <alltraps>

8010653b <vector243>:
.globl vector243
vector243:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $243
8010653d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106542:	e9 63 f1 ff ff       	jmp    801056aa <alltraps>

80106547 <vector244>:
.globl vector244
vector244:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $244
80106549:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010654e:	e9 57 f1 ff ff       	jmp    801056aa <alltraps>

80106553 <vector245>:
.globl vector245
vector245:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $245
80106555:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010655a:	e9 4b f1 ff ff       	jmp    801056aa <alltraps>

8010655f <vector246>:
.globl vector246
vector246:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $246
80106561:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106566:	e9 3f f1 ff ff       	jmp    801056aa <alltraps>

8010656b <vector247>:
.globl vector247
vector247:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $247
8010656d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106572:	e9 33 f1 ff ff       	jmp    801056aa <alltraps>

80106577 <vector248>:
.globl vector248
vector248:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $248
80106579:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010657e:	e9 27 f1 ff ff       	jmp    801056aa <alltraps>

80106583 <vector249>:
.globl vector249
vector249:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $249
80106585:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010658a:	e9 1b f1 ff ff       	jmp    801056aa <alltraps>

8010658f <vector250>:
.globl vector250
vector250:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $250
80106591:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106596:	e9 0f f1 ff ff       	jmp    801056aa <alltraps>

8010659b <vector251>:
.globl vector251
vector251:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $251
8010659d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801065a2:	e9 03 f1 ff ff       	jmp    801056aa <alltraps>

801065a7 <vector252>:
.globl vector252
vector252:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $252
801065a9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801065ae:	e9 f7 f0 ff ff       	jmp    801056aa <alltraps>

801065b3 <vector253>:
.globl vector253
vector253:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $253
801065b5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801065ba:	e9 eb f0 ff ff       	jmp    801056aa <alltraps>

801065bf <vector254>:
.globl vector254
vector254:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $254
801065c1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801065c6:	e9 df f0 ff ff       	jmp    801056aa <alltraps>

801065cb <vector255>:
.globl vector255
vector255:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $255
801065cd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801065d2:	e9 d3 f0 ff ff       	jmp    801056aa <alltraps>
801065d7:	66 90                	xchg   %ax,%ax
801065d9:	66 90                	xchg   %ax,%ax
801065db:	66 90                	xchg   %ax,%ax
801065dd:	66 90                	xchg   %ax,%ax
801065df:	90                   	nop

801065e0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801065e0:	55                   	push   %ebp
801065e1:	89 e5                	mov    %esp,%ebp
801065e3:	57                   	push   %edi
801065e4:	56                   	push   %esi
801065e5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801065e6:	89 d3                	mov    %edx,%ebx
{
801065e8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
801065ea:	c1 eb 16             	shr    $0x16,%ebx
801065ed:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801065f0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801065f3:	8b 06                	mov    (%esi),%eax
801065f5:	a8 01                	test   $0x1,%al
801065f7:	74 27                	je     80106620 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801065f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801065fe:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106604:	c1 ef 0a             	shr    $0xa,%edi
}
80106607:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010660a:	89 fa                	mov    %edi,%edx
8010660c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106612:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106615:	5b                   	pop    %ebx
80106616:	5e                   	pop    %esi
80106617:	5f                   	pop    %edi
80106618:	5d                   	pop    %ebp
80106619:	c3                   	ret    
8010661a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106620:	85 c9                	test   %ecx,%ecx
80106622:	74 2c                	je     80106650 <walkpgdir+0x70>
80106624:	e8 67 be ff ff       	call   80102490 <kalloc>
80106629:	85 c0                	test   %eax,%eax
8010662b:	89 c3                	mov    %eax,%ebx
8010662d:	74 21                	je     80106650 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010662f:	83 ec 04             	sub    $0x4,%esp
80106632:	68 00 10 00 00       	push   $0x1000
80106637:	6a 00                	push   $0x0
80106639:	50                   	push   %eax
8010663a:	e8 01 de ff ff       	call   80104440 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010663f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106645:	83 c4 10             	add    $0x10,%esp
80106648:	83 c8 07             	or     $0x7,%eax
8010664b:	89 06                	mov    %eax,(%esi)
8010664d:	eb b5                	jmp    80106604 <walkpgdir+0x24>
8010664f:	90                   	nop
}
80106650:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106653:	31 c0                	xor    %eax,%eax
}
80106655:	5b                   	pop    %ebx
80106656:	5e                   	pop    %esi
80106657:	5f                   	pop    %edi
80106658:	5d                   	pop    %ebp
80106659:	c3                   	ret    
8010665a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106660 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106660:	55                   	push   %ebp
80106661:	89 e5                	mov    %esp,%ebp
80106663:	57                   	push   %edi
80106664:	56                   	push   %esi
80106665:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106666:	89 d3                	mov    %edx,%ebx
80106668:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010666e:	83 ec 1c             	sub    $0x1c,%esp
80106671:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106674:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106678:	8b 7d 08             	mov    0x8(%ebp),%edi
8010667b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106680:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106683:	8b 45 0c             	mov    0xc(%ebp),%eax
80106686:	29 df                	sub    %ebx,%edi
80106688:	83 c8 01             	or     $0x1,%eax
8010668b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010668e:	eb 15                	jmp    801066a5 <mappages+0x45>
    if(*pte & PTE_P)
80106690:	f6 00 01             	testb  $0x1,(%eax)
80106693:	75 45                	jne    801066da <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106695:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106698:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010669b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010669d:	74 31                	je     801066d0 <mappages+0x70>
      break;
    a += PGSIZE;
8010669f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801066a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066a8:	b9 01 00 00 00       	mov    $0x1,%ecx
801066ad:	89 da                	mov    %ebx,%edx
801066af:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801066b2:	e8 29 ff ff ff       	call   801065e0 <walkpgdir>
801066b7:	85 c0                	test   %eax,%eax
801066b9:	75 d5                	jne    80106690 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801066bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801066be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066c3:	5b                   	pop    %ebx
801066c4:	5e                   	pop    %esi
801066c5:	5f                   	pop    %edi
801066c6:	5d                   	pop    %ebp
801066c7:	c3                   	ret    
801066c8:	90                   	nop
801066c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801066d3:	31 c0                	xor    %eax,%eax
}
801066d5:	5b                   	pop    %ebx
801066d6:	5e                   	pop    %esi
801066d7:	5f                   	pop    %edi
801066d8:	5d                   	pop    %ebp
801066d9:	c3                   	ret    
      panic("remap");
801066da:	83 ec 0c             	sub    $0xc,%esp
801066dd:	68 0c 78 10 80       	push   $0x8010780c
801066e2:	e8 89 9c ff ff       	call   80100370 <panic>
801066e7:	89 f6                	mov    %esi,%esi
801066e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066f0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801066f0:	55                   	push   %ebp
801066f1:	89 e5                	mov    %esp,%ebp
801066f3:	57                   	push   %edi
801066f4:	56                   	push   %esi
801066f5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801066f6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801066fc:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
801066fe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106704:	83 ec 1c             	sub    $0x1c,%esp
80106707:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010670a:	39 d3                	cmp    %edx,%ebx
8010670c:	73 66                	jae    80106774 <deallocuvm.part.0+0x84>
8010670e:	89 d6                	mov    %edx,%esi
80106710:	eb 3d                	jmp    8010674f <deallocuvm.part.0+0x5f>
80106712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106718:	8b 10                	mov    (%eax),%edx
8010671a:	f6 c2 01             	test   $0x1,%dl
8010671d:	74 26                	je     80106745 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010671f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106725:	74 58                	je     8010677f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106727:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010672a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106730:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106733:	52                   	push   %edx
80106734:	e8 a7 bb ff ff       	call   801022e0 <kfree>
      *pte = 0;
80106739:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010673c:	83 c4 10             	add    $0x10,%esp
8010673f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106745:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010674b:	39 f3                	cmp    %esi,%ebx
8010674d:	73 25                	jae    80106774 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010674f:	31 c9                	xor    %ecx,%ecx
80106751:	89 da                	mov    %ebx,%edx
80106753:	89 f8                	mov    %edi,%eax
80106755:	e8 86 fe ff ff       	call   801065e0 <walkpgdir>
    if(!pte)
8010675a:	85 c0                	test   %eax,%eax
8010675c:	75 ba                	jne    80106718 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010675e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106764:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010676a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106770:	39 f3                	cmp    %esi,%ebx
80106772:	72 db                	jb     8010674f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106774:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106777:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010677a:	5b                   	pop    %ebx
8010677b:	5e                   	pop    %esi
8010677c:	5f                   	pop    %edi
8010677d:	5d                   	pop    %ebp
8010677e:	c3                   	ret    
        panic("kfree");
8010677f:	83 ec 0c             	sub    $0xc,%esp
80106782:	68 a6 71 10 80       	push   $0x801071a6
80106787:	e8 e4 9b ff ff       	call   80100370 <panic>
8010678c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106790 <seginit>:
{
80106790:	55                   	push   %ebp
80106791:	89 e5                	mov    %esp,%ebp
80106793:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106796:	e8 d5 cf ff ff       	call   80103770 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010679b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801067a1:	31 c9                	xor    %ecx,%ecx
801067a3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801067a8:	66 89 90 f8 27 11 80 	mov    %dx,-0x7feed808(%eax)
801067af:	66 89 88 fa 27 11 80 	mov    %cx,-0x7feed806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801067b6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801067bb:	31 c9                	xor    %ecx,%ecx
801067bd:	66 89 90 00 28 11 80 	mov    %dx,-0x7feed800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801067c4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801067c9:	66 89 88 02 28 11 80 	mov    %cx,-0x7feed7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801067d0:	31 c9                	xor    %ecx,%ecx
801067d2:	66 89 90 08 28 11 80 	mov    %dx,-0x7feed7f8(%eax)
801067d9:	66 89 88 0a 28 11 80 	mov    %cx,-0x7feed7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801067e0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801067e5:	31 c9                	xor    %ecx,%ecx
801067e7:	66 89 90 10 28 11 80 	mov    %dx,-0x7feed7f0(%eax)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801067ee:	c6 80 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%eax)
  pd[0] = size-1;
801067f5:	ba 2f 00 00 00       	mov    $0x2f,%edx
801067fa:	c6 80 fd 27 11 80 9a 	movb   $0x9a,-0x7feed803(%eax)
80106801:	c6 80 fe 27 11 80 cf 	movb   $0xcf,-0x7feed802(%eax)
80106808:	c6 80 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010680f:	c6 80 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%eax)
80106816:	c6 80 05 28 11 80 92 	movb   $0x92,-0x7feed7fb(%eax)
8010681d:	c6 80 06 28 11 80 cf 	movb   $0xcf,-0x7feed7fa(%eax)
80106824:	c6 80 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010682b:	c6 80 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%eax)
80106832:	c6 80 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%eax)
80106839:	c6 80 0e 28 11 80 cf 	movb   $0xcf,-0x7feed7f2(%eax)
80106840:	c6 80 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106847:	66 89 88 12 28 11 80 	mov    %cx,-0x7feed7ee(%eax)
8010684e:	c6 80 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%eax)
80106855:	c6 80 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%eax)
8010685c:	c6 80 16 28 11 80 cf 	movb   $0xcf,-0x7feed7ea(%eax)
80106863:	c6 80 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010686a:	05 f0 27 11 80       	add    $0x801127f0,%eax
8010686f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106873:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106877:	c1 e8 10             	shr    $0x10,%eax
8010687a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010687e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106881:	0f 01 10             	lgdtl  (%eax)
}
80106884:	c9                   	leave  
80106885:	c3                   	ret    
80106886:	8d 76 00             	lea    0x0(%esi),%esi
80106889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106890 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106890:	a1 a4 54 11 80       	mov    0x801154a4,%eax
{
80106895:	55                   	push   %ebp
80106896:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106898:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010689d:	0f 22 d8             	mov    %eax,%cr3
}
801068a0:	5d                   	pop    %ebp
801068a1:	c3                   	ret    
801068a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068b0 <switchuvm>:
{
801068b0:	55                   	push   %ebp
801068b1:	89 e5                	mov    %esp,%ebp
801068b3:	57                   	push   %edi
801068b4:	56                   	push   %esi
801068b5:	53                   	push   %ebx
801068b6:	83 ec 1c             	sub    $0x1c,%esp
801068b9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801068bc:	85 f6                	test   %esi,%esi
801068be:	0f 84 cd 00 00 00    	je     80106991 <switchuvm+0xe1>
  if(p->kstack == 0)
801068c4:	8b 46 08             	mov    0x8(%esi),%eax
801068c7:	85 c0                	test   %eax,%eax
801068c9:	0f 84 dc 00 00 00    	je     801069ab <switchuvm+0xfb>
  if(p->pgdir == 0)
801068cf:	8b 7e 04             	mov    0x4(%esi),%edi
801068d2:	85 ff                	test   %edi,%edi
801068d4:	0f 84 c4 00 00 00    	je     8010699e <switchuvm+0xee>
  pushcli();
801068da:	e8 b1 d9 ff ff       	call   80104290 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801068df:	e8 0c ce ff ff       	call   801036f0 <mycpu>
801068e4:	89 c3                	mov    %eax,%ebx
801068e6:	e8 05 ce ff ff       	call   801036f0 <mycpu>
801068eb:	89 c7                	mov    %eax,%edi
801068ed:	e8 fe cd ff ff       	call   801036f0 <mycpu>
801068f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801068f5:	83 c7 08             	add    $0x8,%edi
801068f8:	e8 f3 cd ff ff       	call   801036f0 <mycpu>
801068fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106900:	83 c0 08             	add    $0x8,%eax
80106903:	ba 67 00 00 00       	mov    $0x67,%edx
80106908:	c1 e8 18             	shr    $0x18,%eax
8010690b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106912:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106919:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106920:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106927:	83 c1 08             	add    $0x8,%ecx
8010692a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106930:	c1 e9 10             	shr    $0x10,%ecx
80106933:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106939:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
8010693e:	e8 ad cd ff ff       	call   801036f0 <mycpu>
80106943:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010694a:	e8 a1 cd ff ff       	call   801036f0 <mycpu>
8010694f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106954:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106958:	e8 93 cd ff ff       	call   801036f0 <mycpu>
8010695d:	8b 56 08             	mov    0x8(%esi),%edx
80106960:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106966:	89 48 0c             	mov    %ecx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106969:	e8 82 cd ff ff       	call   801036f0 <mycpu>
8010696e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106972:	b8 28 00 00 00       	mov    $0x28,%eax
80106977:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010697a:	8b 46 04             	mov    0x4(%esi),%eax
8010697d:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106982:	0f 22 d8             	mov    %eax,%cr3
}
80106985:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106988:	5b                   	pop    %ebx
80106989:	5e                   	pop    %esi
8010698a:	5f                   	pop    %edi
8010698b:	5d                   	pop    %ebp
  popcli();
8010698c:	e9 ef d9 ff ff       	jmp    80104380 <popcli>
    panic("switchuvm: no process");
80106991:	83 ec 0c             	sub    $0xc,%esp
80106994:	68 12 78 10 80       	push   $0x80107812
80106999:	e8 d2 99 ff ff       	call   80100370 <panic>
    panic("switchuvm: no pgdir");
8010699e:	83 ec 0c             	sub    $0xc,%esp
801069a1:	68 3d 78 10 80       	push   $0x8010783d
801069a6:	e8 c5 99 ff ff       	call   80100370 <panic>
    panic("switchuvm: no kstack");
801069ab:	83 ec 0c             	sub    $0xc,%esp
801069ae:	68 28 78 10 80       	push   $0x80107828
801069b3:	e8 b8 99 ff ff       	call   80100370 <panic>
801069b8:	90                   	nop
801069b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069c0 <inituvm>:
{
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	57                   	push   %edi
801069c4:	56                   	push   %esi
801069c5:	53                   	push   %ebx
801069c6:	83 ec 1c             	sub    $0x1c,%esp
801069c9:	8b 75 10             	mov    0x10(%ebp),%esi
801069cc:	8b 45 08             	mov    0x8(%ebp),%eax
801069cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801069d2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801069d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801069db:	77 49                	ja     80106a26 <inituvm+0x66>
  mem = kalloc();
801069dd:	e8 ae ba ff ff       	call   80102490 <kalloc>
  memset(mem, 0, PGSIZE);
801069e2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
801069e5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801069e7:	68 00 10 00 00       	push   $0x1000
801069ec:	6a 00                	push   $0x0
801069ee:	50                   	push   %eax
801069ef:	e8 4c da ff ff       	call   80104440 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801069f4:	58                   	pop    %eax
801069f5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801069fb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a00:	5a                   	pop    %edx
80106a01:	6a 06                	push   $0x6
80106a03:	50                   	push   %eax
80106a04:	31 d2                	xor    %edx,%edx
80106a06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a09:	e8 52 fc ff ff       	call   80106660 <mappages>
  memmove(mem, init, sz);
80106a0e:	89 75 10             	mov    %esi,0x10(%ebp)
80106a11:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106a14:	83 c4 10             	add    $0x10,%esp
80106a17:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106a1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a1d:	5b                   	pop    %ebx
80106a1e:	5e                   	pop    %esi
80106a1f:	5f                   	pop    %edi
80106a20:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106a21:	e9 ca da ff ff       	jmp    801044f0 <memmove>
    panic("inituvm: more than a page");
80106a26:	83 ec 0c             	sub    $0xc,%esp
80106a29:	68 51 78 10 80       	push   $0x80107851
80106a2e:	e8 3d 99 ff ff       	call   80100370 <panic>
80106a33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a40 <loaduvm>:
{
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	57                   	push   %edi
80106a44:	56                   	push   %esi
80106a45:	53                   	push   %ebx
80106a46:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106a49:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106a50:	0f 85 91 00 00 00    	jne    80106ae7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106a56:	8b 75 18             	mov    0x18(%ebp),%esi
80106a59:	31 db                	xor    %ebx,%ebx
80106a5b:	85 f6                	test   %esi,%esi
80106a5d:	75 1a                	jne    80106a79 <loaduvm+0x39>
80106a5f:	eb 6f                	jmp    80106ad0 <loaduvm+0x90>
80106a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a68:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a6e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106a74:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106a77:	76 57                	jbe    80106ad0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106a79:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a7c:	8b 45 08             	mov    0x8(%ebp),%eax
80106a7f:	31 c9                	xor    %ecx,%ecx
80106a81:	01 da                	add    %ebx,%edx
80106a83:	e8 58 fb ff ff       	call   801065e0 <walkpgdir>
80106a88:	85 c0                	test   %eax,%eax
80106a8a:	74 4e                	je     80106ada <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106a8c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106a8e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106a91:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106a96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106a9b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106aa1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106aa4:	01 d9                	add    %ebx,%ecx
80106aa6:	05 00 00 00 80       	add    $0x80000000,%eax
80106aab:	57                   	push   %edi
80106aac:	51                   	push   %ecx
80106aad:	50                   	push   %eax
80106aae:	ff 75 10             	pushl  0x10(%ebp)
80106ab1:	e8 9a ae ff ff       	call   80101950 <readi>
80106ab6:	83 c4 10             	add    $0x10,%esp
80106ab9:	39 c7                	cmp    %eax,%edi
80106abb:	74 ab                	je     80106a68 <loaduvm+0x28>
}
80106abd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ac5:	5b                   	pop    %ebx
80106ac6:	5e                   	pop    %esi
80106ac7:	5f                   	pop    %edi
80106ac8:	5d                   	pop    %ebp
80106ac9:	c3                   	ret    
80106aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ad0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ad3:	31 c0                	xor    %eax,%eax
}
80106ad5:	5b                   	pop    %ebx
80106ad6:	5e                   	pop    %esi
80106ad7:	5f                   	pop    %edi
80106ad8:	5d                   	pop    %ebp
80106ad9:	c3                   	ret    
      panic("loaduvm: address should exist");
80106ada:	83 ec 0c             	sub    $0xc,%esp
80106add:	68 6b 78 10 80       	push   $0x8010786b
80106ae2:	e8 89 98 ff ff       	call   80100370 <panic>
    panic("loaduvm: addr must be page aligned");
80106ae7:	83 ec 0c             	sub    $0xc,%esp
80106aea:	68 0c 79 10 80       	push   $0x8010790c
80106aef:	e8 7c 98 ff ff       	call   80100370 <panic>
80106af4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106afa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b00 <allocuvm>:
{
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	57                   	push   %edi
80106b04:	56                   	push   %esi
80106b05:	53                   	push   %ebx
80106b06:	83 ec 0c             	sub    $0xc,%esp
80106b09:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
80106b0c:	85 ff                	test   %edi,%edi
80106b0e:	78 7b                	js     80106b8b <allocuvm+0x8b>
  if(newsz < oldsz)
80106b10:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106b13:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106b16:	72 75                	jb     80106b8d <allocuvm+0x8d>
  a = PGROUNDUP(oldsz);
80106b18:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106b1e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106b24:	39 df                	cmp    %ebx,%edi
80106b26:	77 43                	ja     80106b6b <allocuvm+0x6b>
80106b28:	eb 6e                	jmp    80106b98 <allocuvm+0x98>
80106b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106b30:	83 ec 04             	sub    $0x4,%esp
80106b33:	68 00 10 00 00       	push   $0x1000
80106b38:	6a 00                	push   $0x0
80106b3a:	50                   	push   %eax
80106b3b:	e8 00 d9 ff ff       	call   80104440 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106b40:	58                   	pop    %eax
80106b41:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106b47:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b4c:	5a                   	pop    %edx
80106b4d:	6a 06                	push   $0x6
80106b4f:	50                   	push   %eax
80106b50:	89 da                	mov    %ebx,%edx
80106b52:	8b 45 08             	mov    0x8(%ebp),%eax
80106b55:	e8 06 fb ff ff       	call   80106660 <mappages>
80106b5a:	83 c4 10             	add    $0x10,%esp
80106b5d:	85 c0                	test   %eax,%eax
80106b5f:	78 47                	js     80106ba8 <allocuvm+0xa8>
  for(; a < newsz; a += PGSIZE){
80106b61:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b67:	39 df                	cmp    %ebx,%edi
80106b69:	76 2d                	jbe    80106b98 <allocuvm+0x98>
    mem = kalloc();
80106b6b:	e8 20 b9 ff ff       	call   80102490 <kalloc>
    if(mem == 0){
80106b70:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106b72:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106b74:	75 ba                	jne    80106b30 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106b76:	83 ec 0c             	sub    $0xc,%esp
80106b79:	68 89 78 10 80       	push   $0x80107889
80106b7e:	e8 dd 9a ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106b83:	83 c4 10             	add    $0x10,%esp
80106b86:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106b89:	77 4f                	ja     80106bda <allocuvm+0xda>
      return 0;
80106b8b:	31 c0                	xor    %eax,%eax
}
80106b8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b90:	5b                   	pop    %ebx
80106b91:	5e                   	pop    %esi
80106b92:	5f                   	pop    %edi
80106b93:	5d                   	pop    %ebp
80106b94:	c3                   	ret    
80106b95:	8d 76 00             	lea    0x0(%esi),%esi
80106b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  for(; a < newsz; a += PGSIZE){
80106b9b:	89 f8                	mov    %edi,%eax
}
80106b9d:	5b                   	pop    %ebx
80106b9e:	5e                   	pop    %esi
80106b9f:	5f                   	pop    %edi
80106ba0:	5d                   	pop    %ebp
80106ba1:	c3                   	ret    
80106ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106ba8:	83 ec 0c             	sub    $0xc,%esp
80106bab:	68 a1 78 10 80       	push   $0x801078a1
80106bb0:	e8 ab 9a ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106bb5:	83 c4 10             	add    $0x10,%esp
80106bb8:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106bbb:	76 0d                	jbe    80106bca <allocuvm+0xca>
80106bbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106bc0:	8b 45 08             	mov    0x8(%ebp),%eax
80106bc3:	89 fa                	mov    %edi,%edx
80106bc5:	e8 26 fb ff ff       	call   801066f0 <deallocuvm.part.0>
      kfree(mem);
80106bca:	83 ec 0c             	sub    $0xc,%esp
80106bcd:	56                   	push   %esi
80106bce:	e8 0d b7 ff ff       	call   801022e0 <kfree>
      return 0;
80106bd3:	83 c4 10             	add    $0x10,%esp
80106bd6:	31 c0                	xor    %eax,%eax
80106bd8:	eb b3                	jmp    80106b8d <allocuvm+0x8d>
80106bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106bdd:	8b 45 08             	mov    0x8(%ebp),%eax
80106be0:	89 fa                	mov    %edi,%edx
80106be2:	e8 09 fb ff ff       	call   801066f0 <deallocuvm.part.0>
      return 0;
80106be7:	31 c0                	xor    %eax,%eax
80106be9:	eb a2                	jmp    80106b8d <allocuvm+0x8d>
80106beb:	90                   	nop
80106bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106bf0 <deallocuvm>:
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106bf6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106bfc:	39 d1                	cmp    %edx,%ecx
80106bfe:	73 10                	jae    80106c10 <deallocuvm+0x20>
}
80106c00:	5d                   	pop    %ebp
80106c01:	e9 ea fa ff ff       	jmp    801066f0 <deallocuvm.part.0>
80106c06:	8d 76 00             	lea    0x0(%esi),%esi
80106c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106c10:	89 d0                	mov    %edx,%eax
80106c12:	5d                   	pop    %ebp
80106c13:	c3                   	ret    
80106c14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c20 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106c20:	55                   	push   %ebp
80106c21:	89 e5                	mov    %esp,%ebp
80106c23:	57                   	push   %edi
80106c24:	56                   	push   %esi
80106c25:	53                   	push   %ebx
80106c26:	83 ec 0c             	sub    $0xc,%esp
80106c29:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106c2c:	85 f6                	test   %esi,%esi
80106c2e:	74 59                	je     80106c89 <freevm+0x69>
80106c30:	31 c9                	xor    %ecx,%ecx
80106c32:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106c37:	89 f0                	mov    %esi,%eax
80106c39:	e8 b2 fa ff ff       	call   801066f0 <deallocuvm.part.0>
80106c3e:	89 f3                	mov    %esi,%ebx
80106c40:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106c46:	eb 0f                	jmp    80106c57 <freevm+0x37>
80106c48:	90                   	nop
80106c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c50:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106c53:	39 fb                	cmp    %edi,%ebx
80106c55:	74 23                	je     80106c7a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106c57:	8b 03                	mov    (%ebx),%eax
80106c59:	a8 01                	test   $0x1,%al
80106c5b:	74 f3                	je     80106c50 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106c5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106c62:	83 ec 0c             	sub    $0xc,%esp
80106c65:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106c68:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106c6d:	50                   	push   %eax
80106c6e:	e8 6d b6 ff ff       	call   801022e0 <kfree>
80106c73:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106c76:	39 fb                	cmp    %edi,%ebx
80106c78:	75 dd                	jne    80106c57 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106c7a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106c7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c80:	5b                   	pop    %ebx
80106c81:	5e                   	pop    %esi
80106c82:	5f                   	pop    %edi
80106c83:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106c84:	e9 57 b6 ff ff       	jmp    801022e0 <kfree>
    panic("freevm: no pgdir");
80106c89:	83 ec 0c             	sub    $0xc,%esp
80106c8c:	68 bd 78 10 80       	push   $0x801078bd
80106c91:	e8 da 96 ff ff       	call   80100370 <panic>
80106c96:	8d 76 00             	lea    0x0(%esi),%esi
80106c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ca0 <setupkvm>:
{
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	56                   	push   %esi
80106ca4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106ca5:	e8 e6 b7 ff ff       	call   80102490 <kalloc>
80106caa:	85 c0                	test   %eax,%eax
80106cac:	89 c6                	mov    %eax,%esi
80106cae:	74 42                	je     80106cf2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106cb0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106cb3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106cb8:	68 00 10 00 00       	push   $0x1000
80106cbd:	6a 00                	push   $0x0
80106cbf:	50                   	push   %eax
80106cc0:	e8 7b d7 ff ff       	call   80104440 <memset>
80106cc5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106cc8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106ccb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106cce:	83 ec 08             	sub    $0x8,%esp
80106cd1:	8b 13                	mov    (%ebx),%edx
80106cd3:	ff 73 0c             	pushl  0xc(%ebx)
80106cd6:	50                   	push   %eax
80106cd7:	29 c1                	sub    %eax,%ecx
80106cd9:	89 f0                	mov    %esi,%eax
80106cdb:	e8 80 f9 ff ff       	call   80106660 <mappages>
80106ce0:	83 c4 10             	add    $0x10,%esp
80106ce3:	85 c0                	test   %eax,%eax
80106ce5:	78 19                	js     80106d00 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106ce7:	83 c3 10             	add    $0x10,%ebx
80106cea:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106cf0:	75 d6                	jne    80106cc8 <setupkvm+0x28>
}
80106cf2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106cf5:	89 f0                	mov    %esi,%eax
80106cf7:	5b                   	pop    %ebx
80106cf8:	5e                   	pop    %esi
80106cf9:	5d                   	pop    %ebp
80106cfa:	c3                   	ret    
80106cfb:	90                   	nop
80106cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106d00:	83 ec 0c             	sub    $0xc,%esp
80106d03:	56                   	push   %esi
      return 0;
80106d04:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106d06:	e8 15 ff ff ff       	call   80106c20 <freevm>
      return 0;
80106d0b:	83 c4 10             	add    $0x10,%esp
}
80106d0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106d11:	89 f0                	mov    %esi,%eax
80106d13:	5b                   	pop    %ebx
80106d14:	5e                   	pop    %esi
80106d15:	5d                   	pop    %ebp
80106d16:	c3                   	ret    
80106d17:	89 f6                	mov    %esi,%esi
80106d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d20 <kvmalloc>:
{
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106d26:	e8 75 ff ff ff       	call   80106ca0 <setupkvm>
80106d2b:	a3 a4 54 11 80       	mov    %eax,0x801154a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d30:	05 00 00 00 80       	add    $0x80000000,%eax
80106d35:	0f 22 d8             	mov    %eax,%cr3
}
80106d38:	c9                   	leave  
80106d39:	c3                   	ret    
80106d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d40 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106d40:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d41:	31 c9                	xor    %ecx,%ecx
{
80106d43:	89 e5                	mov    %esp,%ebp
80106d45:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106d48:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d4b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d4e:	e8 8d f8 ff ff       	call   801065e0 <walkpgdir>
  if(pte == 0)
80106d53:	85 c0                	test   %eax,%eax
80106d55:	74 05                	je     80106d5c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106d57:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106d5a:	c9                   	leave  
80106d5b:	c3                   	ret    
    panic("clearpteu");
80106d5c:	83 ec 0c             	sub    $0xc,%esp
80106d5f:	68 ce 78 10 80       	push   $0x801078ce
80106d64:	e8 07 96 ff ff       	call   80100370 <panic>
80106d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d70 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	56                   	push   %esi
80106d75:	53                   	push   %ebx
80106d76:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106d79:	e8 22 ff ff ff       	call   80106ca0 <setupkvm>
80106d7e:	85 c0                	test   %eax,%eax
80106d80:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106d83:	0f 84 a0 00 00 00    	je     80106e29 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106d89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d8c:	85 c9                	test   %ecx,%ecx
80106d8e:	0f 84 95 00 00 00    	je     80106e29 <copyuvm+0xb9>
80106d94:	31 f6                	xor    %esi,%esi
80106d96:	eb 4e                	jmp    80106de6 <copyuvm+0x76>
80106d98:	90                   	nop
80106d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106da0:	83 ec 04             	sub    $0x4,%esp
80106da3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106da9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106dac:	68 00 10 00 00       	push   $0x1000
80106db1:	57                   	push   %edi
80106db2:	50                   	push   %eax
80106db3:	e8 38 d7 ff ff       	call   801044f0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106db8:	58                   	pop    %eax
80106db9:	5a                   	pop    %edx
80106dba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106dbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106dc0:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106dc5:	53                   	push   %ebx
80106dc6:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106dcc:	52                   	push   %edx
80106dcd:	89 f2                	mov    %esi,%edx
80106dcf:	e8 8c f8 ff ff       	call   80106660 <mappages>
80106dd4:	83 c4 10             	add    $0x10,%esp
80106dd7:	85 c0                	test   %eax,%eax
80106dd9:	78 39                	js     80106e14 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
80106ddb:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106de1:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106de4:	76 43                	jbe    80106e29 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106de6:	8b 45 08             	mov    0x8(%ebp),%eax
80106de9:	31 c9                	xor    %ecx,%ecx
80106deb:	89 f2                	mov    %esi,%edx
80106ded:	e8 ee f7 ff ff       	call   801065e0 <walkpgdir>
80106df2:	85 c0                	test   %eax,%eax
80106df4:	74 3e                	je     80106e34 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80106df6:	8b 18                	mov    (%eax),%ebx
80106df8:	f6 c3 01             	test   $0x1,%bl
80106dfb:	74 44                	je     80106e41 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
80106dfd:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106dff:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80106e05:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106e0b:	e8 80 b6 ff ff       	call   80102490 <kalloc>
80106e10:	85 c0                	test   %eax,%eax
80106e12:	75 8c                	jne    80106da0 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106e14:	83 ec 0c             	sub    $0xc,%esp
80106e17:	ff 75 e0             	pushl  -0x20(%ebp)
80106e1a:	e8 01 fe ff ff       	call   80106c20 <freevm>
  return 0;
80106e1f:	83 c4 10             	add    $0x10,%esp
80106e22:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80106e29:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e2f:	5b                   	pop    %ebx
80106e30:	5e                   	pop    %esi
80106e31:	5f                   	pop    %edi
80106e32:	5d                   	pop    %ebp
80106e33:	c3                   	ret    
      panic("copyuvm: pte should exist");
80106e34:	83 ec 0c             	sub    $0xc,%esp
80106e37:	68 d8 78 10 80       	push   $0x801078d8
80106e3c:	e8 2f 95 ff ff       	call   80100370 <panic>
      panic("copyuvm: page not present");
80106e41:	83 ec 0c             	sub    $0xc,%esp
80106e44:	68 f2 78 10 80       	push   $0x801078f2
80106e49:	e8 22 95 ff ff       	call   80100370 <panic>
80106e4e:	66 90                	xchg   %ax,%ax

80106e50 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106e50:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e51:	31 c9                	xor    %ecx,%ecx
{
80106e53:	89 e5                	mov    %esp,%ebp
80106e55:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106e58:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e5b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e5e:	e8 7d f7 ff ff       	call   801065e0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106e63:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106e65:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80106e66:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106e68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80106e6d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106e70:	05 00 00 00 80       	add    $0x80000000,%eax
80106e75:	83 fa 05             	cmp    $0x5,%edx
80106e78:	ba 00 00 00 00       	mov    $0x0,%edx
80106e7d:	0f 45 c2             	cmovne %edx,%eax
}
80106e80:	c3                   	ret    
80106e81:	eb 0d                	jmp    80106e90 <copyout>
80106e83:	90                   	nop
80106e84:	90                   	nop
80106e85:	90                   	nop
80106e86:	90                   	nop
80106e87:	90                   	nop
80106e88:	90                   	nop
80106e89:	90                   	nop
80106e8a:	90                   	nop
80106e8b:	90                   	nop
80106e8c:	90                   	nop
80106e8d:	90                   	nop
80106e8e:	90                   	nop
80106e8f:	90                   	nop

80106e90 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	57                   	push   %edi
80106e94:	56                   	push   %esi
80106e95:	53                   	push   %ebx
80106e96:	83 ec 1c             	sub    $0x1c,%esp
80106e99:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106e9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106e9f:	8b 7d 10             	mov    0x10(%ebp),%edi
80106ea2:	85 db                	test   %ebx,%ebx
80106ea4:	75 40                	jne    80106ee6 <copyout+0x56>
80106ea6:	eb 70                	jmp    80106f18 <copyout+0x88>
80106ea8:	90                   	nop
80106ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106eb0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106eb3:	89 f1                	mov    %esi,%ecx
80106eb5:	29 d1                	sub    %edx,%ecx
80106eb7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106ebd:	39 d9                	cmp    %ebx,%ecx
80106ebf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106ec2:	29 f2                	sub    %esi,%edx
80106ec4:	83 ec 04             	sub    $0x4,%esp
80106ec7:	01 d0                	add    %edx,%eax
80106ec9:	51                   	push   %ecx
80106eca:	57                   	push   %edi
80106ecb:	50                   	push   %eax
80106ecc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106ecf:	e8 1c d6 ff ff       	call   801044f0 <memmove>
    len -= n;
    buf += n;
80106ed4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80106ed7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80106eda:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80106ee0:	01 cf                	add    %ecx,%edi
  while(len > 0){
80106ee2:	29 cb                	sub    %ecx,%ebx
80106ee4:	74 32                	je     80106f18 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80106ee6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106ee8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80106eeb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106eee:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106ef4:	56                   	push   %esi
80106ef5:	ff 75 08             	pushl  0x8(%ebp)
80106ef8:	e8 53 ff ff ff       	call   80106e50 <uva2ka>
    if(pa0 == 0)
80106efd:	83 c4 10             	add    $0x10,%esp
80106f00:	85 c0                	test   %eax,%eax
80106f02:	75 ac                	jne    80106eb0 <copyout+0x20>
  }
  return 0;
}
80106f04:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f0c:	5b                   	pop    %ebx
80106f0d:	5e                   	pop    %esi
80106f0e:	5f                   	pop    %edi
80106f0f:	5d                   	pop    %ebp
80106f10:	c3                   	ret    
80106f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f1b:	31 c0                	xor    %eax,%eax
}
80106f1d:	5b                   	pop    %ebx
80106f1e:	5e                   	pop    %esi
80106f1f:	5f                   	pop    %edi
80106f20:	5d                   	pop    %ebp
80106f21:	c3                   	ret    
