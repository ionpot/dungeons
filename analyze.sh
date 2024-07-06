#!/bin/sh
dcm run\
	--analyze\
	--metrics\
	--analyze-widgets\
	--unused-code\
	--unused-files\
	--exports-completeness\
	lib
