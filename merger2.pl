$|=1;
my $input_file1 = 'data1.txt';	# 入力ファイル１。contig length, アノテーションのある方
my $input_file2 = 'data2.txt';	# 入力ファイル２。contig name +TPMデータのみのもの
my $data1_start = 2;			# 入力ファイル１のラベル列の数。普通は２。contig lengthが含まれない場合等は減らす
my $data2_start = 1;			# 入力ファイル２のラベル列の数。普通は１。contig length等が含まれる場合はその分増やす
my $deliminator = "\t";			# 区切り文字。"\t" はtab。コンマの場合は ','こう書く。
my $output_file = 'output.txt';	# 出力ファイル

# ファイルを開く
open IN1, $input_file1;
open IN2, $input_file2;
my @data1 = <IN1>;
my @data2 = <IN2>;
close IN1;
close IN2;

# 列の数を数える
my @test_s1 = split(/$deliminator/,$data1[5]);
my $data1_columns = @test_s1;
my @test_s2 = split(/$deliminator/,$data2[5]);
my $data2_columns = @test_s2;

# 行の数を数える
my $data1_lines = @data1;
my $data2_lines = @data2;

# ソートする
my @data1_sorted = sort @data1;
my @data2_sorted = sort @data2;

# 計算開始
my $data1_num = 0;
my $data2_num = 0;
open OUT, '>'.$output_file;
my $flag = 0;
my $start;
while($flag==0){
	$data1_sorted[$data1_num] =~ s/\r|\n|\r\n//g;
	$data2_sorted[$data2_num] =~ s/\r|\n|\r\n//g;
	my @s1 = split(/$deliminator/,$data1_sorted[$data1_num]);
	my @s2 = split(/$deliminator/,$data2_sorted[$data2_num]);
	if($s1[0] eq $s2[0]){					# 両方の入力にデータがあるcontig
		print OUT $s1[0];
		for(my $i=1;$i<$data1_start;$i++){print OUT "\t".$s1[$i]}
		for(my $i=$data2_start;$i<$data2_columns;$i++){print OUT "\t".$s2[$i]}
		for(my $i=$data1_start;$i<$data1_columns;$i++){print OUT "\t".$s1[$i]}
		print OUT "\n";
		$data1_num++;
		$data2_num++;
	}else{
		my @list = ($s1[0], $s2[0]);
		my @list_sorted = sort(@list);
		if($list_sorted[0] eq $s1[0]){		# 入力１だけデータがあるcontig
			print OUT $s1[0];
			for(my $i=1;$i<$data1_start;$i++){print OUT "\t".$s1[$i]}
			for(my $i=$data2_start;$i<$data2_columns;$i++){print OUT "\t"}
			for(my $i=$data1_start;$i<$data1_columns;$i++){print OUT "\t".$s1[$i]}
			print OUT "\n";
			$data1_num++;
		}else{								# 入力２だけデータがあるcontig
			print OUT $s2[0];
			for(my $i=1;$i<$data1_start;$i++){print OUT "\t"}
			for(my $i=$data2_start;$i<$data2_columns;$i++){print OUT "\t".$s2[$i]}
			for(my $i=$data1_start;$i<$data1_columns;$i++){print OUT "\t"}
			print OUT "\n";
			$data2_num++;
		}
	}
	if($data1_num == $data1_lines){$flag=1;$start=$data2_num;}
	if($data2_num == $data2_lines){$flag=2;$start=$data1_num;}
	if($data1_num % 10000 == 0){print '.';}
}

if($flag==1){	# 入力１の方が最後まで行って終わった場合。入力２の情報だけ終わるまで出力する
	for(my $i=$start;$i<$data2_lines;$i++){
		$data2_sorted[$data2_num] =~ s/\r|\n|\r\n//g;
		my @s2 = split(/$deliminator/,$data2_sorted[$data2_num]);
			print OUT $s2[0];
			for(my $i=1;$i<$data1_start;$i++){print OUT "\t"}
			for(my $i=$data2_start;$i<$data2_columns;$i++){print OUT "\t".$s2[$i]}
			for(my $i=$data1_start;$i<$data1_columns;$i++){print OUT "\t"}
			print OUT "\n";
			$data2_num++;
	}
}
if($flag==2){	# 入力２の方が最後まで行って終わった場合。入力１の情報だけ終わるまで出力する
	for(my $i=$start;$i<$data1_lines;$i++){
		$data1_sorted[$data1_num] =~ s/\r|\n|\r\n//g;
		my @s1 = split(/$deliminator/,$data1_sorted[$data1_num]);
			print OUT $s1[0];
			for(my $i=1;$i<$data1_start;$i++){print OUT "\t".$s1[$i]}
			for(my $i=$data2_start;$i<$data2_columns;$i++){print OUT "\t"}
			for(my $i=$data1_start;$i<$data1_columns;$i++){print OUT "\t".$s1[$i]}
			print OUT "\n";
			$data1_num++;
	}
}
close OUT;
