REM ����һ������ ImageMagick ����Ƭ��С�ű�
REM ֻ���ͼƬ�Ϸŵ��ýű��ϼ���
REM ���磺�Ϸ� bg.png�������� bg_0_0.png, bg_1_0.png ... bg_x_y.png �����ĸ�ʽ

REM �޸� SIZE �ɵ�����Ƭ�ĳߴ磬Ĭ���� 512 ����
SET SIZE=512
convert -verbose %1 -crop %SIZE%x%SIZE% -set filename:tile "%%[fx:page.x/%SIZE%]_%%[fx:page.y/%SIZE%]" +repage +adjoin "%~n1_%%[filename:tile]%~x1"