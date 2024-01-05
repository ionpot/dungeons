#!/bin/sh
dcm run\
	--analyze\
	--metrics\
	--analyze-widgets\
	--unused-code\
	--unused-files\
	--unnecessary-nullable\
	--exports-completeness\
	lib
