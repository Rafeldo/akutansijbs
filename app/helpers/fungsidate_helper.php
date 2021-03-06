<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
if ( ! function_exists('bulan')) {
	function bulan($bln) {
		switch ($bln) {
			case 1: return "Januari";
			break;
			case 2: return "Februari";
			break;
			case 3: return "Maret";
			break;
			case 4: return "April";
			break;
			case 5: return "Mei";
			break;
			case 6: return "Juni";
			break;
			case 7: return "Juli";
			break;
			case 8: return "Agustus";
			break;
			case 9: return "September";
			break;
			case 10: return "Oktober";
			break;
			case 11: return "November";
			break;
			case 12: return "Desember";
			break;
		}
	}
}
if ( ! function_exists('akhirbulan')) {
	function akhirbulan($tgl) {
		$bulan 		= bulan(intval(date_format(date_create($tgl), 'm')));
		$tahun 		= date_format(date_create($tgl), 'Y');
		$dateToTest = $tgl;
		$lastday 	= date('t',strtotime($dateToTest));
		return $lastday . " " . $bulan . " " . $tahun;
	}
}
if ( ! function_exists('tgl_indo')) {
	function tgl_indo($tgl) {
		$ubah = gmdate($tgl, time()+60*60*8);
		$pecah = explode("-",$ubah);
		$tanggal = $pecah[2];
		$bulan = bulan($pecah[1]);
		$tahun = $pecah[0];
		return $tanggal.' '.$bulan.' '.$tahun;
	}
}
if( ! function_exists('tgl_indo_timestamp')) {
	function tgl_indo_timestamp($tgl) {
		$inttime=date('Y-m-d H:i:s',$tgl);
		$tglBaru=explode(" ",$inttime);
		$tglBaru1=$tglBaru[0];
		$tglBaru2=$tglBaru[1];
		$tglBarua=explode("-",$tglBaru1);
		$tgl=$tglBarua[2];
		$bln=$tglBarua[1];
		$thn=$tglBarua[0];
		$bln=bulan($bln);
		$ubahTanggal="$tgl $bln $thn | $tglBaru2 ";
		return $ubahTanggal;
	}
}
function alert_php2($judul ="", $alert = "", $message = "", $t = "") {
	$bb = $alert;
	if($alert=="validate") {
		$bb = "danger";
	}
	$_div_alert     = '<div class="alert alert-'.$bb.' alert-dismissible fade in">';
	if($t=="") {
		$_div_alert     .= '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>';
	}
	if($alert=="success") {
		$_div_alert     .= '<b><i class="icon fa fa-check"></i>' . $judul . '</b>';
	} else if($alert=="danger") {
		$_div_alert     .= '<b><i class="icon fa fa-ban"></i>' . $judul . '</b>';
	} else if($alert=="warning") {
		$_div_alert     .= '<b><i class="icon fa fa-warning"></i>' . $judul . '</b>';
	} else if($alert=="info") {
		$_div_alert     .= '<b><i class="icon fa fa-info"></i>' . $judul . '</b>';
	} else if($alert=="validate") {
	}
	$_div_alert     .=  $message;
	$_div_alert     .= '</div>';
	return $_div_alert;
}
function rupiah2($harga, $separator = ".", $digit = 0, $mata_uang = "") {
	$angka      = number_format($harga, $digit);
	$str_angka  = str_replace(",", "A", $angka);
	$str_angka  = str_replace(".", ",", $str_angka);
	$str_angka  = str_replace("A", ".", $str_angka);
	if($mata_uang!="") {
		$str_angka = $mata_uang . " " . $str_angka;
	}
	return $str_angka;
}
