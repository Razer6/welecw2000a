/*****************************************************************************
 * File           : symbols.c
 * Author         : Robert Schilling <robert.schilling at gmx.at>
 * Date           : 07.05.2010
 *****************************************************************************
 * Description	 :
 *****************************************************************************

 *  Copyright (c) 2010, Schilling Robert

 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

 *  For commercial applications where source-code distribution is not
 *  desirable or possible, I offer low-cost commercial IP licenses.
 *  Please contact me per mail.

 *****************************************************************************
 * Remarks		: -
 * Revision		: 0
 ****************************************************************************/
 
#include "DSO_Screen.h"

/* Arrow up for SubMenuList */
sSymbol sym_up = {
	.width = 9,
	.height = 5,
	.data = {
		0x08, 0x00, 
		0x1c, 0x00, 
		0x3e, 0x00, 
		0x7f, 0x00, 
		0xff, 0x80}
	};

/* Image for Trigger Level */
sSymbol sym_triggerMark = {
	.width = 18,
	.height = 12,
	.data = {
		0x00, 0x08, 0x00,
		0x00, 0x0c, 0x00,
		0x00, 0x0e, 0x00,
		0x00, 0x0f, 0x00,
		0x00, 0x0f, 0x80,
		0xff, 0xff, 0xc0,
		0xff, 0xff, 0xc0,
		0x00, 0x0f, 0x80,
		0x00, 0x0f, 0x00,
		0x00, 0x0e, 0x00,
		0x00, 0x0c, 0x00,
		0x00, 0x08, 0x00}
};

/* Symbol for rising edge trigger in titlebar */
sSymbol sym_risingEdge = {
	.width = 10,
	.height = 15,
	.data = {
		0x0f, 0xc0, 
		0x0f, 0xc0, 
		0x0c, 0x00, 
		0x0c, 0x00, 
		0x1e, 0x00, 
		0x1e, 0x00, 
		0x7f, 0x80, 
		0x7f, 0x80, 
		0xff, 0xc0, 
		0xff, 0xc0, 
		0x0c, 0x00, 
		0x0c, 0x00, 
		0x0c, 0x00, 
		0xfc, 0x00, 
		0xfc, 0x00}
	};

/* Symbol for falling edge trigger in titlebar */	
sSymbol sym_fallingEdge = {
	.width = 10,
	.height = 15,
	.data = {
		0x0f, 0xc0, 
		0x0f, 0xc0, 
		0x0c, 0x00, 
		0x0c, 0x00, 
		0x0c, 0x00, 
		0xff, 0xc0, 
		0xff, 0xc0, 
		0x7f, 0x80, 
		0x7f, 0x80, 
		0x1e, 0x00, 
		0x1e, 0x00, 
		0x0c, 0x00, 
		0x0c, 0x00, 
		0xfc, 0x00, 
		0xfc, 0x00}
	};
	


