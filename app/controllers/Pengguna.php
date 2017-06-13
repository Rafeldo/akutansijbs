<?php defined('BASEPATH') OR exit('No direct script access allowed');
class Pengguna extends CI_Controller {
	function __construct() {
		parent::__construct();
		$this->load->model('model_pengguna');
		$this->load->library('form_validation');
	}
	public function index() {
		$data['judul'] 		= 'Daftar Pengguna';
		$data['pengguna'] 	= $this->model_pengguna->listPengguna()->result();
		$this->template->view_baru('pengguna/daftar_pengguna', $data);
	}
	public function tambah() {
		$data['judul'] 		= 'Tambah Pengguna';
		$data['errors'] 	= '';
		$company_id = $this->session->userdata($this->config->item('ses_company_id'));
		$kode_unik = base_convert(microtime(false), 10, 36);
		$btnSimpan = $this->input->post('btnSimpan');
		if($btnSimpan=="simpan") {
			$this->form_validation->set_rules('nama', 'Nama Pengguna', 'required|max_length[50]');
			$this->form_validation->set_rules('email', 'Email Pengguna', 'required|max_length[50]|valid_email|is_unique[mst_pengguna.email]');
			$this->form_validation->set_rules('katasandi', 'Kata Sandi', 'required|min_length[4]|max_length[50]');
			if ($this->form_validation->run() == FALSE) {
			} else {
				$data_create = array('nama' 			=> $this->input->post('nama'), 'email' 		=> $this->input->post('email'), 'katasandi' 	=> md5($this->input->post('katasandi')), 'company_id' 	=> $company_id, 'koderahasia' 	=> $kode_unik, 'verifikasi' 	=> 'A', 'status' 		=> 'A');
				$this->db->set('dibuat', 'NOW()', false);
				$this->db->set('terakhir', 'NOW()', false);
				$this->db->insert('mst_pengguna', $data_create);
				$message = alert_php2('Proses berhasil. ', 'success', 'Data berhasil disimpan');
				$this->session->set_userdata($this->config->item('ses_message'), $message);
				redirect('pengguna');
			}
		}
		$this->template->view_baru('pengguna/tambah_pengguna', $data);
	}
	public function ubah() {
		$id_pengguna 		= $this->uri->segment(3);
		$data['judul'] 		= 'Ubah Pengguna';
		$data['errors'] 	= '';
		$data['pengguna'] 	= $this->model_pengguna->getPengguna($id_pengguna);
		$company_id = $this->session->userdata($this->config->item('ses_company_id'));
		$btnSimpan = $this->input->post('btnSimpan');
		if($btnSimpan=="simpan") {
			$origin_email 	= $data['pengguna']['email'];
			$is_unique 		= '';
			if($this->input->post('email')!=$origin_email) $is_unique =  '|is_unique[mst_pengguna.email]';
			$this->form_validation->set_rules('nama', 'Nama Pengguna', 'required|max_length[50]');
			$this->form_validation->set_rules('email', 'Email Pengguna', 'required|max_length[50]|valid_email'.$is_unique);
			if ($this->form_validation->run() == FALSE) {
			} else {
				$data_update = array('nama' => $this->input->post('nama'), 'email' => $this->input->post('email') );
				if($this->input->post('katasandi')!="") {
					$katasandi = $this->input->post('katasandi');
					$katasandi = md5($katasandi);
					$this->db->set('katasandi', $katasandi);
				}
				$where = "company_id = '$company_id' and md5(id_pengguna) = '$id_pengguna' ";
				$this->db->where($where);
				$this->db->update('mst_pengguna', $data_update);
				$message = alert_php2('Proses berhasil. ', 'success', 'Data berhasil disimpan');
				$this->session->set_userdata($this->config->item('ses_message'), $message);
				redirect('pengguna');
			}
		}
		$this->template->view_baru('pengguna/ubah_pengguna', $data);
	}
	public function profil() {
		$company_id 		= $this->session->userdata($this->config->item('ses_company_id'));
		$id_pengguna 		= md5($this->session->userdata($this->config->item('ses_id')));
		$data['judul'] 	= 'Profil';
		$data['errors'] = '';
		$data['pengguna'] 	= $this->model_pengguna->getPengguna($id_pengguna);
		$this->template->view_baru('pengguna/profil', $data);
	}
	public function login() {
		$data['url'] 	= '';
		$btnlogin 		= $this->input->post('btnlogin');
		if($btnlogin=="dologin") {
			$your_password 	= $this->input->post('your_password');
			$your_email 	= $this->input->post('your_email');
			$this->db->select('*');
			$this->db->where(array('md5(email) =' => md5($your_email), 'katasandi = ' => md5($your_password)));
			$this->db->from('mst_pengguna');
			$data = $this->db->get();
			if($data->num_rows() > 0) {
				$user = $data->row_array();
				if($user["verifikasi"]!="A") {
					$message = alert_php2('Akun anda belum diverifikasi.', 'info', '<br/>Klik <a href="'.base_url('kirim_konfirm').'">disini</a> untuk verifikasi.');
					$this->session->set_userdata($this->config->item('ses_message'), $message);
					redirect('login');
				} elseif($user["status"]!="A") {
					$message = alert_php2('Email ini sudah tidak bisa digunakan lagi.', 'info', '');
					$this->session->set_userdata($this->config->item('ses_message'), $message);
					redirect('login');
				} else {
					$this->session->set_userdata($this->config->item('ses_id'), $user["id_pengguna"]);
					$this->session->set_userdata($this->config->item('ses_email'), $user["email"]);
					$this->session->set_userdata($this->config->item('ses_name'), $user["nama"]);
					$this->session->set_userdata($this->config->item('ses_create'), $user["dibuat"]);
					$this->session->set_userdata($this->config->item('ses_last'), $user["terakhir"]);
					$this->session->set_userdata($this->config->item('ses_company_id'), $user["company_id"]);
					$this->db->set('terakhir', 'NOW()', FALSE);
					$this->db->where('id_pengguna', $user["id_pengguna"]);
					$update = $this->db->update('mst_pengguna');
					redirect('/');
				}
			} else {
				$message = alert_php2('Login gagal.', 'danger', '');
				$this->session->set_userdata($this->config->item('ses_message'), $message);
				redirect('login');
			}
		}
		$this->load->view('pengguna/login', $data);
	}
	public function logout() {
		$this->session->unset_userdata($this->config->item('ses_id'));
		$this->session->unset_userdata($this->config->item('ses_email'));
		$this->session->unset_userdata($this->config->item('ses_name'));
		$this->session->unset_userdata($this->config->item('ses_create'));
		$this->session->unset_userdata($this->config->item('ses_last'));
		$this->session->unset_userdata($this->config->item('ses_company_id'));
		redirect('login');
	}
}
