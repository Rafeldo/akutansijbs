<?php defined('BASEPATH') OR exit('No direct script access allowed');
class Tutupbuku extends CI_Controller {
	public function __construct() {
		parent::__construct();
		$this->load->model('model_tutupbuku');
	}
	public function index() {
		$data['judul'] = "Tutup Buku";
		$data['tutup'] = $this->model_tutupbuku->listTutupBuku()->result();
		$this->template->view_baru('tutupbuku/daftar', $data);
	}
	public function proses() {
		$data['judul'] = "Tutup Buku";
		$bulan 		= $this->input->post('bulan');
		$tahun 		= $this->input->post('tahun');
		$btnproses 	= $this->input->post('btnproses');
		$company_id = $this->session->userdata($this->config->item('ses_company_id'));
		$id_login 	= $this->session->userdata($this->config->item('ses_id'));
		if($btnproses=="proses") {
			$cekTutupBuku = $this->model_tutupbuku->cekTutupBuku($bulan, $tahun);
			if($cekTutupBuku>0) {
				$message = alert_php2('Sudah dilakukan. ', 'danger', 'Proses tutup buku <b>' . bulan($bulan) . " " . $tahun . "</b> sudah dilakukan.");
				$this->session->set_userdata($this->config->item('ses_message'), $message);
				redirect('tutupbuku/proses');
			} else {
				$bulan_ini = intval(date('m'));
				$tahun_ini = intval(date('Y'));
				$date 		= date('Y-m-d');
				$newdate 	= strtotime ('-1 month', strtotime($date)) ;
				$bulan_m_1 	= date('m', $newdate);
				$tahun_m_1 	= date('Y', $newdate);
				if($bulan > $bulan_ini || $tahun > $tahun_ini) {
					$message = alert_php2('', 'danger', '<b>Proses tutup buku tidak bisa dilakukan karena <i><u>melebihi bulan ini</u></i></b>');
					$this->session->set_userdata($this->config->item('ses_message'), $message);
					redirect('tutupbuku/proses');
				} elseif($bulan < $bulan_m_1 || $tahun < $tahun_m_1) {
					$message = alert_php2('', 'danger', '<b>Proses tutup buku tidak bisa dilakukan karena <i><u>bulan sudah terlewat</u></i></b>');
					$this->session->set_userdata($this->config->item('ses_message'), $message);
					redirect('tutupbuku/proses');
				} else {
					$kode_unik = base_convert(microtime(false), 10, 36);
					$data_simpan = array('periode_tb_bulanan' => $tahun . "-" . $bulan . "-01", 'yang_buat' => $id_login, 'company_id' => $company_id, 'kode_unik' => $kode_unik, 'status' => 'A', 'id_batalkan' => '0');
					$this->db->set('tgl_dibuat', 'NOW()', FALSE);
					$simpan = $this->db->insert('trs_tutup_buku_bulanan', $data_simpan);
					if($simpan) {
						$tmp_periodenya = $tahun."-".$bulan."-01";
						$this->model_tutupbuku->summarySaldo($tmp_periodenya);
						$message = alert_php2('Berhasil. ', 'success', 'Proses tutup buku <b>' . bulan($bulan) . " " . $tahun . "</b> berhasil.");
						$this->session->set_userdata($this->config->item('ses_message'), $message);
						redirect('tutupbuku');
					} else {
						$message = alert_php2('Gagal. ', 'danger', 'Proses tutup buku <b>' . bulan($bulan) . " " . $tahun . "</b> belum berhasil.");
						$this->session->set_userdata($this->config->item('ses_message'), $message);
						redirect('tutupbuku');
					}
				}
			}
		}
		$this->template->view_baru('tutupbuku/form', $data);
	}
	public function rollback() {
		$kode_unik 	= $this->uri->segment(3);
		$company_id = $this->session->userdata($this->config->item('ses_company_id'));
		$id_login 	= $this->session->userdata($this->config->item('ses_id'));
		$cekRollBack = $this->model_tutupbuku->cekRollBack($kode_unik);
		if($cekRollBack>0) {
			$message = alert_php2('', 'danger', '<b>Batalkan tutup buku bulan sesudahnya terlebih dahulu.</b>');
			$this->session->set_userdata($this->config->item('ses_message'), $message);
			redirect('tutupbuku');
		} else {
			$data_updat = array("status" => "N", "id_batalkan" => $id_login );
			$this->db->where('kode_unik', $kode_unik);
			$this->db->where('company_id', $company_id);
			$this->db->update('trs_tutup_buku_bulanan', $data_updat);
			$tmp_periodenya = $this->model_tutupbuku->getPeriode($kode_unik);
			$this->model_tutupbuku->summarySaldoCancel($tmp_periodenya);
			$message = alert_php2('Berhasil. ', 'success', 'Proses tutup buku berhasil dibatalkan.');
			$this->session->set_userdata($this->config->item('ses_message'), $message);
			redirect('tutupbuku');
		}
	}
}
