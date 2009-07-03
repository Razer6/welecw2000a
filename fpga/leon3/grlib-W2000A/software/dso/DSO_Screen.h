

#ifndef DSO_SCREEN_H
#define DSO_SCREEN_H

uint32_t * InitDisplay (uint32_t Target);
/* H1 <= H2 and V1 <= V2 and Hx < HLEN and Vx < VLEN */
void DrawHLine(char Color, uint32_t V, uint32_t H1, uint32_t H2);
/* H1 <= H2 and V1 <= V2 and Hx < HLEN and Vx < VLEN */
void DrawVLine(char Color, uint32_t H, uint32_t V1, uint32_t V2);
/* H1 <= H2 and V1 <= V2 and Hx < HLEN and Vx < VLEN */
void DrawBox(char Color, uint32_t H1, uint32_t V1, uint32_t H2, uint32_t V2);
void DrawTest(void);

#endif
