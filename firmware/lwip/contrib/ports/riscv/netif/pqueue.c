/******************************************************************************
*
* Copyright (C) 2007 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* XILINX CONSORTIUM BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

// #include <stdlib.h>

#include "pqueue.h"
// #include "mylib.h"

#define NUM_QUEUES	2

pq_queue_t pq_queue[NUM_QUEUES];

pq_queue_t *
pq_create_queue()
{
	static int i;
	pq_queue_t *q = ((void *)0);

	if (i >= NUM_QUEUES) {
		// xil_printf("ERR: Max Queues allocated\n\r");
		return q;
	}

	q = &pq_queue[i++];

	if (!q)
		return q;

	q->head = q->tail = q->len = 0;

	return q;
}

int
pq_enqueue(pq_queue_t *q, void *p, int idx)
{
	if (q->len == PQ_QUEUE_SIZE)
		return -1;

	q->data[q->head] = p;
	q->index[q->head] = idx;
	q->head = (q->head + 1)%PQ_QUEUE_SIZE;
	q->len++;

// printf("pq_en *p %0x, idx %02x, head %d, len %d\n", (void*)p, idx, q->head, q->len);

	return 0;
}

void*
pq_dequeue(pq_queue_t *q)
{
	// int ptail;

	if (q->len == 0)
		return ((void *)0);
// printf("pq_de *p %0x\n", (void*)q->data[q->tail]);
	// ptail = q->tail;
	return q->data[q->tail];
}

int
pq_qindex(pq_queue_t *q)
{
	int pidx;
	if (q->len == 0)
		return ((void *)0);
	// ptail = q->tail;
	pidx = q->index[q->tail];

	q->tail = (q->tail + 1)%PQ_QUEUE_SIZE;
	q->len--;
// printf("pq_qi idx %02x, head %d, len %d\n", pidx, q->tail, q->len);
	return pidx;
}


int
pq_qlength(pq_queue_t *q)
{
	return q->len;
}
