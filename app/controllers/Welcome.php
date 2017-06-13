<?php defined('BASEPATH') OR exit('No direct script access allowed');
class Welcome extends CI_Controller {
	public function __construct() {
		parent::__construct();
	}
	public function index() {
		$this->load->library('user_agent');
		$this->load->model('model_chart');
		$data['judul'] 			= "Dashboard";
		$data['tipe_company'] 	= $this->model_pengguna->getCompanyTipe();
		$data['chart_labarugi'] = $this->model_chart->chart_labarugi()->result();
		$data['mobile'] = $this->agent->is_mobile();
		$this->template->view_baru('welcome/dashboard', $data);
	}
	public function error() {
		$data["error"] = $this->template->not_found_data("Halaman Tidak Ditemukan", "Halaman Yang Anda Minta Tidak Ditemukan.");
		$this->template->view_baru('welcome/error', $data);
	}
}
/*$data['os_browser']= "Sistem Operasi yang Anda gunakan adalah <b>". $this->agent->platform() . "</b> <br/> dengan browser <b>" . $this->agent->browser().' '.$this->agent->version() . '</b>';*/
