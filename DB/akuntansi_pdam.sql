-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Jun 05, 2017 at 12:54 PM
-- Server version: 10.1.19-MariaDB
-- PHP Version: 5.6.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `akuntansi_pdam`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_jurnal` ()  BEGIN
	select * from trs_jurnal;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_buku_besar` (`periode` VARCHAR(10), `tmp_company` BIGINT)  BEGIN

	if periode = '' then
		select * from (
			select trs_neraca_saldo.periode_neraca_saldo as tgl_jurnal, 
				'' as no_jurnal, 
				'Saldo Awal' as memo, 
				mst_akun.kode_akun, 
				mst_akun.nama_akun, 'Saldo Awal' as uraian, 
				
				amount,
				trs_neraca_saldo.debet, 
				trs_neraca_saldo.kredit, 
				'1' as no_urut 
			from trs_neraca_saldo 
			left join mst_akun on mst_akun.id_akun = trs_neraca_saldo.id_akun
			where MONTH(trs_neraca_saldo.periode_neraca_saldo) = MONTH(NOW())
			and YEAR(trs_neraca_saldo.periode_neraca_saldo) = YEAR(NOW())
			and trs_neraca_saldo.company_id = tmp_company
			
			union all
			
			select trs_jurnal.tgl_jurnal, 
				trs_jurnal.no_jurnal, 
				trs_jurnal.memo, 
				mst_akun.kode_akun,
				mst_akun.nama_akun,
				trs_jurnal_detail.uraian, 
				trs_jurnal_detail.amount, 
				trs_jurnal_detail.debet,
				trs_jurnal_detail.kredit, 
				'2' as no_urut 
			from trs_jurnal_detail 
			left join mst_akun on mst_akun.id_akun = trs_jurnal_detail.id_akun 
			left join trs_jurnal on trs_jurnal.id_jurnal = trs_jurnal_detail.id_jurnal 
			where trs_jurnal.dikonfirmasi = 'yes'
			and MONTH(trs_jurnal.tgl_jurnal) = MONTH(NOW())
			and YEAR(trs_jurnal.tgl_jurnal) = YEAR(NOW())
			AND trs_jurnal.company_id = tmp_company
			
		)t1  order by t1.kode_akun asc, t1.no_urut asc, t1.tgl_jurnal asc;
	else
		SELECT * FROM (
			SELECT trs_neraca_saldo.periode_neraca_saldo AS tgl_jurnal,
				'' AS no_jurnal, 
				'Saldo Awal' AS memo,
				mst_akun.kode_akun,
				mst_akun.nama_akun,
				'Saldo Awal' AS uraian, 
				
				amount,
				trs_neraca_saldo.debet,
				trs_neraca_saldo.kredit, 
				'1' AS no_urut 
			FROM trs_neraca_saldo 
			LEFT JOIN mst_akun ON mst_akun.id_akun = trs_neraca_saldo.id_akun
			WHERE MONTH(trs_neraca_saldo.periode_neraca_saldo) = SUBSTR(periode, 1, 2)
			AND YEAR(trs_neraca_saldo.periode_neraca_saldo) = SUBSTR(periode, 4, 4)
			and trs_neraca_saldo.company_id = tmp_company
			
			UNION ALL
			
			SELECT trs_jurnal.tgl_jurnal,
				trs_jurnal.no_jurnal,
				trs_jurnal.memo, 
				mst_akun.kode_akun,
				mst_akun.nama_akun,
				trs_jurnal_detail.uraian, 
				trs_jurnal_detail.amount, 
				trs_jurnal_detail.debet,
				trs_jurnal_detail.kredit,
				'2' AS no_urut 
			FROM trs_jurnal_detail 
			LEFT JOIN mst_akun ON mst_akun.id_akun = trs_jurnal_detail.id_akun 
			LEFT JOIN trs_jurnal ON trs_jurnal.id_jurnal = trs_jurnal_detail.id_jurnal 
			WHERE trs_jurnal.dikonfirmasi = 'yes'
			AND MONTH(trs_jurnal.tgl_jurnal) = SUBSTR(periode, 1, 2)
			AND YEAR(trs_jurnal.tgl_jurnal) = SUBSTR(periode, 4, 4)
			AND trs_jurnal.company_id = tmp_company
			
		)t1  ORDER BY t1.kode_akun ASC, t1.no_urut ASC, t1.tgl_jurnal ASC;
	end if;
	
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_chart_laba_rugi` (`tmp_company` BIGINT)  BEGIN
	SELECT (DATE_FORMAT(periode_laba_rugi, '%b %Y'))as periode , laba_rugi
	FROM trs_laba_rugi
	WHERE 
	
		YEAR(periode_laba_rugi) = YEAR(NOW())
		and company_id = tmp_company
	order by periode_laba_rugi asc;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_akun_awal` (`tmp_company` BIGINT)  BEGIN
	INSERT INTO `mst_akun` (`id_tipe_akun`, `kode_akun`, `nama_akun`, `saldo_normal`, 
	`lokasi`, `posisi`, `tgl_dibuat`, `tgl_diubah`, `aktif`, `company_id`) VALUES
	(13, '110001', 'Kas', 'D', 'Neraca', 1, '2016-07-28 11:29:47', '2017-02-17 10:45:52', 'A', tmp_company),
	(1, '110003', 'Perlengkapan', 'D', 'Neraca', 3, '2016-07-28 11:37:00', '2016-07-28 12:01:51', 'A', tmp_company),
	(4, '210001', 'Hutang Lancar', 'K', 'Neraca', 4, '2016-08-26 09:37:02', '2016-08-26 09:37:02', 'A', tmp_company),
	(6, '310001', 'Modal Usaha', 'K', 'Neraca', 5, '2016-08-26 09:37:19', '2016-08-26 09:37:19', 'A', tmp_company),
	(6, '310002', 'Laba (Rugi) Ditahan', 'K', 'Neraca', 3, '2017-02-20 10:30:50', '2017-02-20 10:30:50', 'A', tmp_company),
	(6, '310003', 'Laba (Rugi) Bulan Berjalan', 'K', 'Neraca', 3, '2017-02-20 10:30:50', '2017-02-20 10:30:50', 'A', tmp_company),
	(7, '410001', 'Penjualan', 'K', 'Profit', 6, '2016-08-26 09:37:34', '2017-02-10 15:37:05', 'A', tmp_company),	
	(9, '511000', 'Harga Pokok Penjualan', 'D', 'Profit', 2, '2017-02-17 10:52:43', '2017-02-17 10:52:43', 'A', tmp_company);
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_jurnal_umum` (`periode` VARCHAR(10), `tmp_company` BIGINT)  BEGIN
	IF periode = '' THEN
		SELECT trs_jurnal.tgl_jurnal,
			trs_jurnal.no_jurnal,
			trs_jurnal.memo,
			mst_akun.kode_akun,
			mst_akun.nama_akun,
			trs_jurnal_detail.uraian,
			trs_jurnal_detail.amount,
			trs_jurnal_detail.debet,
			trs_jurnal_detail.kredit
		FROM trs_jurnal_detail
		LEFT JOIN mst_akun ON mst_akun.id_akun = trs_jurnal_detail.id_akun
		LEFT JOIN trs_jurnal ON trs_jurnal.id_jurnal = trs_jurnal_detail.id_jurnal
		WHERE trs_jurnal.dikonfirmasi = 'Yes'
		and MONTH(trs_jurnal.tgl_jurnal) = month(NOW())
		and year(trs_jurnal.tgl_jurnal) = year(NOW())
		and trs_jurnal.jenis_jurnal = 'JU'
		and trs_jurnal.company_id = tmp_company
		ORDER BY trs_jurnal.tgl_jurnal asc, trs_jurnal_detail.id_jurnal_detail ASC;
	else
		SELECT trs_jurnal.tgl_jurnal,
			trs_jurnal.no_jurnal,
			trs_jurnal.memo,
			mst_akun.kode_akun,
			mst_akun.nama_akun,
			trs_jurnal_detail.uraian,
			trs_jurnal_detail.amount,
			trs_jurnal_detail.debet,
			trs_jurnal_detail.kredit
		FROM trs_jurnal_detail
		LEFT JOIN mst_akun ON mst_akun.id_akun = trs_jurnal_detail.id_akun
		LEFT JOIN trs_jurnal ON trs_jurnal.id_jurnal = trs_jurnal_detail.id_jurnal
		WHERE trs_jurnal.dikonfirmasi = 'Yes'
		AND MONTH(trs_jurnal.tgl_jurnal) = SUBSTR(periode, 1, 2)
		AND YEAR(trs_jurnal.tgl_jurnal) = SUBSTR(periode, 4, 4)
		AND trs_jurnal.jenis_jurnal = 'JU'
		AND trs_jurnal.company_id = tmp_company
		ORDER BY trs_jurnal.tgl_jurnal ASC, trs_jurnal_detail.id_jurnal_detail ASC;
	end if;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_laba_rugi` (`periode` VARCHAR(10), `tmp_company` BIGINT)  BEGIN
	if periode = '' then
		SELECT a.kode_akun, a.nama_akun, tp.nama_tipe_akun,
			(SELECT IFNULL(SUM(amount),0) FROM trs_jurnal_detail AS jd
				WHERE jd.id_akun = a.id_akun
				AND jd.id_jurnal IN (
					SELECT id_jurnal FROM trs_jurnal WHERE dikonfirmasi = 'Yes'
					AND MONTH(tgl_jurnal) = MONTH(NOW())
					AND YEAR(tgl_jurnal) = YEAR(NOW())
					and company_id = tmp_company
				)
				)AS amount,
			(CASE WHEN SUBSTRING(a.kode_akun,1,1) = '4' THEN '1'
				ELSE  (CASE WHEN SUBSTRING(a.kode_akun,1,1) = '7' THEN '2'
				ELSE  (CASE WHEN SUBSTRING(a.kode_akun,1,1) = '5' THEN '3'
				ELSE (CASE WHEN SUBSTRING(a.kode_akun,1,1) = '6' THEN '4'
				ELSE  '5'
				END)END)END)end)no_urut,
			SUBSTRING(a.kode_akun,1,1) AS no_depan
		FROM mst_akun AS a
		LEFT JOIN mst_tipeakun AS tp ON tp.id_tipe_akun = a.id_tipe_akun
		WHERE SUBSTRING(a.kode_akun,1,1) IN ('4', '5', '6', '7', '8')
		AND a.company_id = tmp_company
		ORDER BY no_urut asc;
	else
		SELECT a.kode_akun, a.nama_akun, tp.nama_tipe_akun,
			(SELECT IFNULL(SUM(amount),0) FROM trs_jurnal_detail AS jd
				WHERE jd.id_akun = a.id_akun
				AND jd.id_jurnal IN (
					SELECT id_jurnal FROM trs_jurnal WHERE dikonfirmasi = 'Yes'
					AND MONTH(tgl_jurnal) = SUBSTR(periode, 1, 2)
					AND YEAR(tgl_jurnal) = SUBSTR(periode, 4, 4)
					AND company_id = tmp_company
				)
				)AS amount,
			(CASE WHEN SUBSTRING(a.kode_akun,1,1) = '4' THEN '1'
				ELSE  (CASE WHEN SUBSTRING(a.kode_akun,1,1) = '7' THEN '2'
				ELSE  (CASE WHEN SUBSTRING(a.kode_akun,1,1) = '5' THEN '3'
				ELSE (CASE WHEN SUBSTRING(a.kode_akun,1,1) = '6' THEN '4'
				ELSE  '5'
				END)END)END)END)no_urut,
			SUBSTRING(a.kode_akun,1,1) as no_depan
		FROM mst_akun AS a
		LEFT JOIN mst_tipeakun AS tp ON tp.id_tipe_akun = a.id_tipe_akun
		WHERE SUBSTRING(a.kode_akun,1,1) IN ('4', '5', '6', '7', '8')
		AND a.company_id = tmp_company
		ORDER BY no_urut ASC;
	end if;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_laba_rugi_insert` (`tmp_periode` VARCHAR(10), `tmp_company` BIGINT)  BEGIN
	declare periode date;
	DECLARE pendapatan FLOAT;
	DECLARE pendapatan_lain FLOAT;
	declare HPP float;
	DECLARE beban FLOAT;
	DECLARE biaya_produksi float;
	DECLARE beban_lain FLOAT;
	DECLARE laba_rugi FLOAT;
	DECLARE sudah_ada INT;
	
	SET pendapatan = (SELECT IFNULL(SUM(jd.amount),0) AS amount
			FROM trs_jurnal_detail AS jd
			LEFT JOIN trs_jurnal AS j ON j.id_jurnal = jd.id_jurnal
			LEFT JOIN mst_akun AS a ON a.id_akun = jd.id_akun
			WHERE j.dikonfirmasi = 'Yes' 
			AND MONTH(j.tgl_jurnal) = month(tmp_periode)
			AND YEAR(j.tgl_jurnal) = year(tmp_periode)
			AND SUBSTRING(a.kode_akun,1,1) = '4'
			and j.company_id = tmp_company);
	
	SET HPP = (SELECT IFNULL(SUM(jd.amount),0) AS amount
			FROM trs_jurnal_detail AS jd
			LEFT JOIN trs_jurnal AS j ON j.id_jurnal = jd.id_jurnal
			LEFT JOIN mst_akun AS a ON a.id_akun = jd.id_akun
			WHERE j.dikonfirmasi = 'Yes' 
			AND MONTH(j.tgl_jurnal) = MONTH(tmp_periode)
			AND YEAR(j.tgl_jurnal) = YEAR(tmp_periode)
			AND SUBSTRING(a.kode_akun,1,1) = '5'
			AND j.company_id = tmp_company);
			
	SET beban = (SELECT IFNULL(SUM(jd.amount),0) AS amount
			FROM trs_jurnal_detail AS jd
			LEFT JOIN trs_jurnal AS j ON j.id_jurnal = jd.id_jurnal
			LEFT JOIN mst_akun AS a ON a.id_akun = jd.id_akun
			WHERE j.dikonfirmasi = 'Yes' 
			AND MONTH(j.tgl_jurnal) = MONTH(tmp_periode)
			AND YEAR(j.tgl_jurnal) = YEAR(tmp_periode)
			AND SUBSTRING(a.kode_akun,1,2) = '61'
			AND j.company_id = tmp_company);
	
	SET biaya_produksi = (SELECT IFNULL(SUM(jd.amount),0) AS amount
			FROM trs_jurnal_detail AS jd
			LEFT JOIN trs_jurnal AS j ON j.id_jurnal = jd.id_jurnal
			LEFT JOIN mst_akun AS a ON a.id_akun = jd.id_akun
			WHERE j.dikonfirmasi = 'Yes' 
			AND MONTH(j.tgl_jurnal) = MONTH(tmp_periode)
			AND YEAR(j.tgl_jurnal) = YEAR(tmp_periode)
			AND SUBSTRING(a.kode_akun,1,2) = '62'
			AND j.company_id = tmp_company);
	
	SET pendapatan_lain = (SELECT IFNULL(SUM(jd.amount),0) AS amount
			FROM trs_jurnal_detail AS jd
			LEFT JOIN trs_jurnal AS j ON j.id_jurnal = jd.id_jurnal
			LEFT JOIN mst_akun AS a ON a.id_akun = jd.id_akun
			WHERE j.dikonfirmasi = 'Yes' 
			AND MONTH(j.tgl_jurnal) = MONTH(tmp_periode)
			AND YEAR(j.tgl_jurnal) = YEAR(tmp_periode)
			AND SUBSTRING(a.kode_akun,1,1) = '7'
			and j.company_id = tmp_company);
	
	
	
	SET beban_lain = (SELECT IFNULL(SUM(jd.amount),0) AS amount
			FROM trs_jurnal_detail AS jd
			LEFT JOIN trs_jurnal AS j ON j.id_jurnal = jd.id_jurnal
			LEFT JOIN mst_akun AS a ON a.id_akun = jd.id_akun
			WHERE j.dikonfirmasi = 'Yes' 
			AND MONTH(j.tgl_jurnal) = MONTH(tmp_periode)
			AND YEAR(j.tgl_jurnal) = YEAR(tmp_periode)
			AND SUBSTRING(a.kode_akun,1,1) = '8'
			and j.company_id = tmp_company);
			
	SET laba_rugi = ABS(pendapatan) + ABS(pendapatan_lain) - ABS(HPP) - ABS(beban) - ABS(biaya_produksi) - ABS(beban_lain);
	
	
	
	SET sudah_ada = (SELECT COUNT(*) FROM trs_laba_rugi 
				WHERE MONTH(periode_laba_rugi) = MONTH(tmp_periode)
				AND YEAR(periode_laba_rugi) = YEAR(tmp_periode)
				and company_id = tmp_company);
	
	SET periode = DATE_FORMAT(tmp_periode ,'%Y-%m-01');
	
	IF sudah_ada > 0 THEN
		UPDATE trs_laba_rugi SET laba_rugi = laba_rugi
			WHERE MONTH(periode_laba_rugi) = MONTH(tmp_periode)
				AND YEAR(periode_laba_rugi) = YEAR(tmp_periode)
				and company_id = tmp_company;
	ELSE
		INSERT INTO trs_laba_rugi (periode_laba_rugi, laba_rugi, company_id) VALUES(periode, laba_rugi, tmp_company);
	END IF;
	
	
	
	
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_neraca` (`periode` VARCHAR(10), `tmp_company` BIGINT)  BEGIN
    
	SELECT ns.periode_neraca_saldo, 
		a.kode_akun, 
		a.nama_akun,
		t.nama_tipe_akun,
		(CASE WHEN a.nama_akun != 'Laba (Rugi) Bulan Berjalan' THEN
			ns.amount ELSE
			(CASE WHEN ns.amount < 0 THEN ns.amount ELSE (-1 * ns.amount) END)END) AS amount,
		(CASE WHEN a.nama_akun != 'Laba (Rugi) Bulan Berjalan' THEN
			ns.debet ELSE
			(CASE WHEN ns.amount > 0 THEN 0 ELSE (-1 * ns.amount) END)END) AS debet,
		(CASE WHEN a.nama_akun != 'Laba (Rugi) Bulan Berjalan' THEN
			ns.kredit ELSE
			(CASE WHEN ns.amount < 0 THEN 0 ELSE (ns.amount) END)END) AS kredit,
		(case when SUBSTR(a.kode_akun, 1, 1) = '1' then 'Aktiva' else 'Pasiva' end) as jenis
	
	FROM trs_neraca_saldo AS ns
	
	INNER JOIN mst_akun AS a ON a.id_akun = ns.id_akun
	
	INNER JOIN mst_tipeakun AS t ON a.id_tipe_akun = t.id_tipe_akun
	
	WHERE a.id_tipe_akun IN (1, 2, 3, 4, 5, 6, 13) AND ns.company_id = tmp_company
	
	AND MONTH(DATE_ADD(ns.periode_neraca_saldo, INTERVAL -1 MONTH)) = SUBSTR(periode, 1, 2)
	
	AND YEAR(DATE_ADD(ns.periode_neraca_saldo, INTERVAL -1 MONTH)) = SUBSTR(periode, 4, 4)
	
	order by a.kode_akun;
	
	
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_summary_saldo` (`periode` VARCHAR(10), `tmp_company` BIGINT)  BEGIN
	DECLARE periode_plus_1 date;
	DECLARE periode_min_1 DATE;
	
	
	set periode_plus_1 = date_add(periode, interval 1 month);
	
	SET periode_min_1 = DATE_ADD(periode, INTERVAL -1 MONTH);
	
	SET periode = DATE_ADD(periode, INTERVAL 0 MONTH);
		
	
	insert into trs_neraca_saldo (periode_neraca_saldo, id_akun, amount, debet, kredit, company_id)
	SELECT 	periode_plus_1,
		t1.id_akun,
		SUM(amount) AS amount,
		SUM(debet) AS debet,
		SUM(kredit) AS kredit,
		tmp_company
	FROM (
		SELECT a.id_akun, 
			a.kode_akun, 
			a.nama_akun,
			(case when a.nama_akun = 'Laba (Rugi) Bulan Berjalan' then 
				IFNULL((select (-1 * laba_rugi) from trs_laba_rugi
					where MONTH(periode_laba_rugi) = MONTH(periode)
					and year(periode_laba_rugi) = YEAR(periode)
					and company_id = tmp_company),0)
				else
				
				(case when a.nama_akun = 'Laba (Rugi) Ditahan' then 
					IFNULL((SELECT (-1 * laba_rugi) FROM trs_laba_rugi
						WHERE MONTH(periode_laba_rugi) = MONTH(periode_min_1)
						AND YEAR(periode_laba_rugi) = YEAR(periode_min_1)
						AND company_id = tmp_company),0) + 
					ifnull((select (amount) from trs_neraca_saldo
						WHERE MONTH(periode_neraca_saldo) = MONTH(periode)
						AND YEAR(periode_neraca_saldo) = YEAR(periode)
						and company_id = tmp_company
						and id_akun = (select id_akun from mst_akun
									where mst_akun.company_id = tmp_company
									and nama_akun = 'Laba (Rugi) Ditahan')),0)
					
					else					
					IFNULL((SELECT amount FROM trs_neraca_saldo WHERE
						id_akun = a.id_akun 
						AND MONTH(periode_neraca_saldo) = MONTH(periode)
							AND YEAR(periode_neraca_saldo) = YEAR(periode)),0)end)end) AS amount,
						
			IFNULL((SELECT debet FROM trs_neraca_saldo WHERE
				id_akun = a.id_akun 
				AND MONTH(periode_neraca_saldo) = MONTH(periode)
					AND YEAR(periode_neraca_saldo) = YEAR(periode)),0) AS debet,
					
			IFNULL((SELECT kredit FROM trs_neraca_saldo WHERE
				id_akun = a.id_akun 
				AND MONTH(periode_neraca_saldo) = MONTH(periode)
					AND YEAR(periode_neraca_saldo) = YEAR(periode)),0) AS kredit
		FROM mst_akun AS a
		WHERE a.company_id = tmp_company
		
		UNION ALL
		
		SELECT mst_akun.id_akun, 
			mst_akun.kode_akun,
			mst_akun.nama_akun,
			ifnull(trs_jurnal_detail.amount, 0) as amount, 
			IFNULL(trs_jurnal_detail.debet, 0) AS debet,
			IFNULL(trs_jurnal_detail.kredit, 0) AS kredit
		FROM trs_jurnal_detail 
		RIGHT JOIN mst_akun ON mst_akun.id_akun = trs_jurnal_detail.id_akun 
		LEFT JOIN trs_jurnal ON trs_jurnal.id_jurnal = trs_jurnal_detail.id_jurnal 
		WHERE trs_jurnal.dikonfirmasi = 'yes'
		AND MONTH(trs_jurnal.tgl_jurnal) = MONTH(periode)
		AND YEAR(trs_jurnal.tgl_jurnal) = YEAR(periode)
		AND trs_jurnal.company_id = tmp_company
		)t1  
	GROUP BY t1.id_akun, t1.kode_akun, t1.nama_akun	
	ORDER BY t1.kode_akun ASC;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_summary_saldo_cancel` (`periode` VARCHAR(10), `tmp_company` BIGINT)  BEGIN
	SET periode = DATE_ADD(periode, INTERVAL 1 MONTH);
	
	delete from trs_neraca_saldo
	where month(periode_neraca_saldo) = month(periode)
		and year(periode_neraca_saldo) = YEAR(periode)
		and company_id = tmp_company;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `mst_akun`
--

CREATE TABLE `mst_akun` (
  `id_akun` int(11) NOT NULL,
  `id_tipe_akun` int(11) NOT NULL,
  `kode_akun` varchar(20) NOT NULL,
  `nama_akun` varchar(50) NOT NULL,
  `saldo_normal` varchar(1) NOT NULL,
  `lokasi` varchar(15) NOT NULL,
  `posisi` int(11) NOT NULL,
  `tgl_dibuat` datetime NOT NULL,
  `tgl_diubah` datetime NOT NULL,
  `aktif` varchar(1) NOT NULL,
  `company_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `mst_akun`
--

INSERT INTO `mst_akun` (`id_akun`, `id_tipe_akun`, `kode_akun`, `nama_akun`, `saldo_normal`, `lokasi`, `posisi`, `tgl_dibuat`, `tgl_diubah`, `aktif`, `company_id`) VALUES
(1, 13, '110001', 'Kas', 'D', 'Neraca', 1, '2016-07-28 11:29:47', '2017-02-17 10:45:52', 'A', 1),
(2, 1, '110003', 'Perlengkapan', 'D', 'Neraca', 3, '2016-07-28 11:37:00', '2016-07-28 12:01:51', 'A', 1),
(3, 4, '210001', 'Hutang Lancar', 'K', 'Neraca', 4, '2016-08-26 09:37:02', '2016-08-26 09:37:02', 'A', 1),
(4, 6, '310001', 'Modal Usaha', 'K', 'Neraca', 5, '2016-08-26 09:37:19', '2017-02-22 23:52:19', 'A', 1),
(5, 6, '310002', 'Laba (Rugi) Ditahan', 'K', 'Neraca', 3, '2017-02-20 10:30:50', '2017-02-20 10:30:50', 'A', 1),
(6, 6, '310003', 'Laba (Rugi) Bulan Berjalan', 'K', 'Neraca', 3, '2017-02-20 10:30:50', '2017-02-20 10:30:50', 'A', 1),
(7, 7, '410001', 'Penjualan', 'K', 'Profit', 6, '2016-08-26 09:37:34', '2017-02-10 15:37:05', 'A', 1),
(8, 9, '511000', 'Harga Pokok Penjualan', 'D', 'Profit', 2, '2017-02-17 10:52:43', '2017-02-17 10:52:43', 'A', 1),
(9, 13, '111111', '11111111111', 'D', 'Neraca', 1, '2017-03-03 15:37:07', '2017-03-23 15:48:14', 'A', 1),
(10, 1, '119000', '1111xxx', 'D', 'Neraca', 0, '2017-03-05 10:50:55', '2017-03-05 10:51:47', 'A', 1),
(11, 2, '129999', 'AKUN BARU', 'D', 'Neraca', 0, '2017-03-05 18:28:44', '2017-03-05 18:28:44', 'A', 1),
(12, 13, '111234', '1234', 'D', 'Neraca', 0, '2017-03-17 13:46:17', '2017-03-17 13:46:17', 'A', 1);

-- --------------------------------------------------------

--
-- Table structure for table `mst_company`
--

CREATE TABLE `mst_company` (
  `company_id` int(11) NOT NULL,
  `company_name` varchar(30) NOT NULL,
  `address` varchar(100) NOT NULL,
  `telp_anda` varchar(20) NOT NULL,
  `email_anda` varchar(50) NOT NULL,
  `tgl_daftar` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `kode_unik` varchar(20) NOT NULL,
  `tipe` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `mst_company`
--

INSERT INTO `mst_company` (`company_id`, `company_name`, `address`, `telp_anda`, `email_anda`, `tgl_daftar`, `kode_unik`, `tipe`) VALUES
(1, 'NAMA PERUSAHAAN', 'ALAMAT 1234', '089628704241', 'aryaubd@gmail.com', '2017-02-22 23:45:07', '6g5burs5sy04', 'Free');

-- --------------------------------------------------------

--
-- Table structure for table `mst_pengguna`
--

CREATE TABLE `mst_pengguna` (
  `id_pengguna` bigint(20) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `katasandi` varchar(60) NOT NULL,
  `dibuat` datetime NOT NULL,
  `terakhir` datetime NOT NULL,
  `company_id` int(11) NOT NULL,
  `koderahasia` varchar(20) NOT NULL,
  `verifikasi` varchar(1) NOT NULL,
  `link_url` varchar(50) NOT NULL,
  `status` varchar(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `mst_pengguna`
--

INSERT INTO `mst_pengguna` (`id_pengguna`, `nama`, `email`, `katasandi`, `dibuat`, `terakhir`, `company_id`, `koderahasia`, `verifikasi`, `link_url`, `status`) VALUES
(1, 'Fuck', 'admin@example.com', '81dc9bdb52d04dc20036dbd8313ed055', '2017-02-22 23:45:07', '2017-05-22 16:33:54', 1, '6g5burs5sy04', 'A', '', 'A'),
(2, 'admin1', 'admin1@gmail.com', '0192023a7bbd73250516f069df18b500', '2017-03-05 10:34:39', '2017-03-05 10:36:16', 1, '5sbjgeh8mj8c', 'A', '', 'A'),
(3, 'coba', 'coba@gmail.com', '0192023a7bbd73250516f069df18b500', '2017-03-05 10:36:29', '2017-03-05 10:36:29', 1, '573yzf36ngws', 'A', '', 'A'),
(4, 'rafeldo', 'rafeldo29@gmail.com', '7777bb4bfb029a24e4760b28f6f06d56', '2017-03-18 16:41:13', '2017-06-05 17:52:36', 1, '50a4x5mo65gk', 'A', '', 'A'),
(5, 'sulaiman', 'rafeldosulaiman3@gmail.com', '9a1c0d75ce2bec1835042cce7363fc1c', '2017-04-01 16:23:48', '2017-04-01 16:23:48', 1, '2szoavkj9dwk', 'A', '', 'A');

-- --------------------------------------------------------

--
-- Table structure for table `mst_tipeakun`
--

CREATE TABLE `mst_tipeakun` (
  `id_tipe_akun` int(11) NOT NULL,
  `kode_tipe_akun` varchar(2) NOT NULL,
  `nama_tipe_akun` varchar(30) NOT NULL,
  `keterangan` varchar(160) DEFAULT NULL,
  `tgl_dibuat` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `tgl_diubah` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `mst_tipeakun`
--

INSERT INTO `mst_tipeakun` (`id_tipe_akun`, `kode_tipe_akun`, `nama_tipe_akun`, `keterangan`, `tgl_dibuat`, `tgl_diubah`) VALUES
(1, '11', 'Aktiva Lancar', NULL, '2016-07-28 06:41:01', '2016-07-19 15:51:48'),
(2, '12', 'Aktiva Tetap', NULL, '2016-07-28 06:41:06', '2016-07-19 15:51:48'),
(3, '14', 'Aktiva Tak Berwujud', NULL, '2017-02-17 03:39:19', '2016-07-19 15:51:52'),
(4, '21', 'Hutang Lancar', NULL, '2016-07-28 06:41:11', '2016-07-19 15:51:48'),
(5, '22', 'Hutang Jangka Panjang', NULL, '2016-07-28 06:41:14', '2016-07-19 15:51:48'),
(6, '31', 'Ekuitas', NULL, '2016-07-28 06:41:17', '2016-07-19 15:51:48'),
(7, '41', 'Penjualan', NULL, '2017-02-17 03:50:25', '2016-07-19 15:51:48'),
(9, '51', 'Biaya Pokok Penjualan', NULL, '2017-02-17 03:50:23', '2016-07-19 15:51:48'),
(10, '61', 'Beban Operasional', NULL, '2017-02-17 03:51:48', '2016-07-19 15:51:48'),
(11, '71', 'Pendapatan Lainnya', NULL, '2017-02-17 03:50:46', '2016-07-19 15:51:48'),
(12, '81', 'Beban Lainnya', NULL, '2017-02-17 03:51:15', '2016-07-28 13:43:19'),
(13, '11', 'Kas & Bank', NULL, '2017-02-21 03:45:29', '2017-02-21 10:45:27'),
(14, '62', 'Biaya Produksi', NULL, '2017-02-22 16:46:30', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `mst_transaksi_akun`
--

CREATE TABLE `mst_transaksi_akun` (
  `id_transaksi_akun` int(11) NOT NULL,
  `nama_transaksi_akun` varchar(50) NOT NULL,
  `tgl_dibuat` datetime NOT NULL,
  `tgl_diubah` datetime NOT NULL,
  `aktif` varchar(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `trs_jurnal`
--

CREATE TABLE `trs_jurnal` (
  `id_jurnal` bigint(20) NOT NULL,
  `no_jurnal` varchar(40) NOT NULL,
  `no_bukti` varchar(40) DEFAULT NULL,
  `memo` varchar(160) DEFAULT NULL,
  `tgl_jurnal` date NOT NULL,
  `total` float NOT NULL,
  `dikonfirmasi` varchar(5) NOT NULL,
  `yang_buat` int(11) NOT NULL,
  `tgl_dibuat` datetime NOT NULL,
  `yang_ubah` int(11) DEFAULT NULL,
  `tgl_diubah` datetime DEFAULT NULL,
  `jenis_jurnal` varchar(5) DEFAULT NULL,
  `kode_unik` varchar(20) NOT NULL,
  `dikonfirmasi_oleh` int(11) NOT NULL,
  `company_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `trs_jurnal`
--

INSERT INTO `trs_jurnal` (`id_jurnal`, `no_jurnal`, `no_bukti`, `memo`, `tgl_jurnal`, `total`, `dikonfirmasi`, `yang_buat`, `tgl_dibuat`, `yang_ubah`, `tgl_diubah`, `jenis_jurnal`, `kode_unik`, `dikonfirmasi_oleh`, `company_id`) VALUES
(1, '29-40-333', NULL, NULL, '2017-04-02', 1000, 'Yes', 0, '2017-04-02 13:54:28', NULL, NULL, 'JU', '5od0hva3hxs8', 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `trs_jurnal_detail`
--

CREATE TABLE `trs_jurnal_detail` (
  `id_jurnal_detail` bigint(20) NOT NULL,
  `id_jurnal` bigint(20) NOT NULL,
  `id_akun` int(11) NOT NULL,
  `uraian` varchar(160) DEFAULT NULL,
  `amount` float NOT NULL,
  `debet` float NOT NULL,
  `kredit` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `trs_jurnal_detail`
--

INSERT INTO `trs_jurnal_detail` (`id_jurnal_detail`, `id_jurnal`, `id_akun`, `uraian`, `amount`, `debet`, `kredit`) VALUES
(1, 1, 1, '', 1000, 1000, 0),
(2, 1, 9, 'pembayaran biaya listrik', -1000, 0, 1000);

-- --------------------------------------------------------

--
-- Table structure for table `trs_laba_rugi`
--

CREATE TABLE `trs_laba_rugi` (
  `id_laba_rugi` bigint(20) NOT NULL,
  `periode_laba_rugi` date NOT NULL,
  `laba_rugi` float NOT NULL,
  `company_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `trs_laba_rugi`
--

INSERT INTO `trs_laba_rugi` (`id_laba_rugi`, `periode_laba_rugi`, `laba_rugi`, `company_id`) VALUES
(1, '2017-02-01', 0, 1),
(2, '2017-03-01', 90000, 1),
(3, '2017-03-01', 0, 0),
(4, '2017-05-01', 0, 1),
(5, '2017-06-01', 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `trs_neraca_saldo`
--

CREATE TABLE `trs_neraca_saldo` (
  `id_neraca_saldo` bigint(20) NOT NULL,
  `periode_neraca_saldo` date NOT NULL,
  `id_akun` int(11) NOT NULL,
  `amount` float NOT NULL,
  `debet` float NOT NULL,
  `kredit` float NOT NULL,
  `company_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `trs_neraca_saldo_tmp`
--

CREATE TABLE `trs_neraca_saldo_tmp` (
  `id_neraca_saldo` bigint(20) NOT NULL,
  `periode_neraca_saldo` date NOT NULL,
  `id_akun` int(11) NOT NULL,
  `amount` float NOT NULL,
  `debet` float NOT NULL,
  `kredit` float NOT NULL,
  `company_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `trs_tutup_buku_bulanan`
--

CREATE TABLE `trs_tutup_buku_bulanan` (
  `id_tb_bulanan` int(11) NOT NULL,
  `periode_tb_bulanan` date NOT NULL,
  `yang_buat` int(11) NOT NULL,
  `tgl_dibuat` datetime NOT NULL,
  `company_id` int(11) NOT NULL,
  `kode_unik` varchar(10) NOT NULL,
  `status` varchar(1) NOT NULL,
  `id_batalkan` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `trs_tutup_buku_bulanan`
--

INSERT INTO `trs_tutup_buku_bulanan` (`id_tb_bulanan`, `periode_tb_bulanan`, `yang_buat`, `tgl_dibuat`, `company_id`, `kode_unik`, `status`, `id_batalkan`) VALUES
(1, '2017-02-01', 1, '2017-03-07 14:38:08', 1, '71lvlq6ta9', 'N', 1),
(2, '2017-03-01', 1, '2017-03-21 16:09:46', 1, '1so6j3492n', 'N', 1),
(3, '2017-03-01', 1, '2017-03-21 16:11:51', 1, 'hkabgfkzpz', 'N', 1),
(4, '2017-03-01', 1, '2017-03-21 16:21:17', 1, '1uy2ns66hx', 'N', 1),
(5, '2017-06-01', 4, '2017-06-05 16:44:36', 1, '4ezkoukjb3', 'N', 4),
(6, '2017-06-01', 4, '2017-06-05 16:46:40', 1, '61l0nqw3iw', 'N', 4);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `mst_akun`
--
ALTER TABLE `mst_akun`
  ADD PRIMARY KEY (`id_akun`);

--
-- Indexes for table `mst_company`
--
ALTER TABLE `mst_company`
  ADD PRIMARY KEY (`company_id`);

--
-- Indexes for table `mst_pengguna`
--
ALTER TABLE `mst_pengguna`
  ADD PRIMARY KEY (`id_pengguna`);

--
-- Indexes for table `mst_tipeakun`
--
ALTER TABLE `mst_tipeakun`
  ADD PRIMARY KEY (`id_tipe_akun`);

--
-- Indexes for table `mst_transaksi_akun`
--
ALTER TABLE `mst_transaksi_akun`
  ADD PRIMARY KEY (`id_transaksi_akun`);

--
-- Indexes for table `trs_jurnal`
--
ALTER TABLE `trs_jurnal`
  ADD PRIMARY KEY (`id_jurnal`);

--
-- Indexes for table `trs_jurnal_detail`
--
ALTER TABLE `trs_jurnal_detail`
  ADD PRIMARY KEY (`id_jurnal_detail`);

--
-- Indexes for table `trs_laba_rugi`
--
ALTER TABLE `trs_laba_rugi`
  ADD PRIMARY KEY (`id_laba_rugi`);

--
-- Indexes for table `trs_neraca_saldo`
--
ALTER TABLE `trs_neraca_saldo`
  ADD PRIMARY KEY (`id_neraca_saldo`);

--
-- Indexes for table `trs_neraca_saldo_tmp`
--
ALTER TABLE `trs_neraca_saldo_tmp`
  ADD PRIMARY KEY (`id_neraca_saldo`);

--
-- Indexes for table `trs_tutup_buku_bulanan`
--
ALTER TABLE `trs_tutup_buku_bulanan`
  ADD PRIMARY KEY (`id_tb_bulanan`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `mst_akun`
--
ALTER TABLE `mst_akun`
  MODIFY `id_akun` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `mst_company`
--
ALTER TABLE `mst_company`
  MODIFY `company_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `mst_pengguna`
--
ALTER TABLE `mst_pengguna`
  MODIFY `id_pengguna` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `mst_tipeakun`
--
ALTER TABLE `mst_tipeakun`
  MODIFY `id_tipe_akun` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
--
-- AUTO_INCREMENT for table `mst_transaksi_akun`
--
ALTER TABLE `mst_transaksi_akun`
  MODIFY `id_transaksi_akun` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `trs_jurnal`
--
ALTER TABLE `trs_jurnal`
  MODIFY `id_jurnal` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `trs_jurnal_detail`
--
ALTER TABLE `trs_jurnal_detail`
  MODIFY `id_jurnal_detail` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `trs_laba_rugi`
--
ALTER TABLE `trs_laba_rugi`
  MODIFY `id_laba_rugi` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `trs_neraca_saldo`
--
ALTER TABLE `trs_neraca_saldo`
  MODIFY `id_neraca_saldo` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;
--
-- AUTO_INCREMENT for table `trs_neraca_saldo_tmp`
--
ALTER TABLE `trs_neraca_saldo_tmp`
  MODIFY `id_neraca_saldo` bigint(20) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `trs_tutup_buku_bulanan`
--
ALTER TABLE `trs_tutup_buku_bulanan`
  MODIFY `id_tb_bulanan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
