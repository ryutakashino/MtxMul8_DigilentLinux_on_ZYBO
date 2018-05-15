rem @echo off

echo %1|python CTRL_MODULE_maker.py      > CTRL_MODULE.v
echo %1|python DOTPRODUCT_MODULE_maker.py > DOTPRODUCT_MODULE.v
echo %1|python INPUT_MODULE_maker.py      > INPUT_MODULE.v
echo %1|python OUTPUT_MODULE_maker.py     > OUTPUT_MODULE.v
echo %1|python main_module_maker.py       > main.v
