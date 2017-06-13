<?php defined('BASEPATH') OR exit('No direct script access allowed');
/** * */
class Model_pengguna extends CI_Model {
	function listPengguna() {
		$tipe 		= $this->getCompanyTipe();
		$company_id = $this->session->userdata($this->config->item('ses_company_id'));
		$this->db->select('*');
		$this->db->where('company_id', $company_id);
		$this->db->from('mst_pengguna');
		if($tipe=="Free") return $this->db->limit(0,2)->get(); else return $this->db->get();
	}
	function countPengguna() {
		$company_id = $this->session->userdata($this->config->item('ses_company_id'));
		$this->db->select('count(*) as banyak');
		$this->db->where('company_id', $company_id);
		$this->db->from('mst_pengguna');
		$data = $this->db->get()->row_array();
		return $data["banyak"];
	}
	function getCompanyTipe() {
		$company_id = $this->session->userdata($this->config->item('ses_company_id'));
		$this->db->select('tipe');
		$this->db->where('company_id', $company_id);
		$this->db->from('mst_company');
		$data = $this->db->get()->row_array();
		return $data["tipe"];
	}
	function getCompanyID($kode_unik, $email) {
		$this->db->select('company_id');
		$where = "kode_unik = '$kode_unik' and email_anda = '$email' ";
		$this->db->where($where);
		$this->db->from('mst_company');
		$data = $this->db->get()->row_array();
		return $data["company_id"];
	}
	function insertAkunAwal($company_id) {
		$sql 		= "CALL sp_insert_akun_awal('".$company_id."');";
		$this->db->query($sql);
		/*mysqli_next_result($this->db->conn_id);*/
	}
	function getPengguna($id_pengguna) {
		$company_id = $this->session->userdata($this->config->item('ses_company_id'));
		$this->db->select('*');
		$where = "company_id = '$company_id' and md5(id_pengguna) = '$id_pengguna' ";
		$this->db->where($where);
		$this->db->from('mst_pengguna');
		return $this->db->get()->row_array();
	}
}
