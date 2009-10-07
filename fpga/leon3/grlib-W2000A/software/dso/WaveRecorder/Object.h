//////////////////////////////////////////////////////////////////////////////
// Workfile		: Object.h
// Author		: Alexander Lindert
// Date			: 11.04.2006
// Description	: 
// Remarks		: -
// Revision		: 0
//////////////////////////////////////////////////////////////////////////////
#ifndef OBJECT_H
#define OBJECT_H

class Object { 
public:
	virtual ~Object(){}
protected:
	Object(){}
private:
	Object(Object const &);
	Object operator = (Object const &);
};

#endif
