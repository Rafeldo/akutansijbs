<?php defined('BASEPATH') OR exit('No direct script access allowed');
	$menu_a = $this->uri->segment(1);
	$menu_b = $this->uri->segment(2);
?>
<aside class="main-sidebar">
	<section class="sidebar">
		<!-- Sidebar user panel -->
		<div class="user-panel">
		  <div class="pull-left image">
			 <img src="<?=base_url('assets/dist/img/avatar5.png')?>" class="img-circle" alt="User Image">
		  </div>
		  <div class="pull-left info">
			 <p><?php echo $this->session->userdata($this->config->item('ses_name'))!=""?$this->session->userdata($this->config->item('ses_name')):"Administrator"; ?></p>
			 <a href="<?=base_url('profil')?>"><i class="fa fa-circle text-success"></i> Online</a>
		  </div>
		</div>
		<!-- search form -->
		<form action="#" method="get" class="sidebar-form">
		  <div class="input-group">
			 <input type="text" name="q" class="form-control" placeholder="Search...">
				  <span class="input-group-btn">
					 <button type="submit" name="search" id="search-btn" class="btn btn-flat"><i class="fa fa-search"></i>
					 </button>
				  </span>
		  </div>
		</form>
		<!-- /.search form -->
		<ul class="sidebar-menu">
			<li class="header"></li>
			<li <?php if($menu_a=="" || $menu_a=="welcome") echo 'class="active"'; ?>><a href="<?=base_url()?>"><i class="fa fa-dashboard"></i> <span class="kunci">Dashboard</span></a></li>
			<li <?php if($menu_a=="jurnal" && $menu_b != "konfirmasi") echo 'class="active"'; ?>><a href="<?=base_url('jurnal')?>"><i class="fa fa-files-o"></i><span class="kunci">Jurnal</span></a></li>
			<li <?php if($menu_a=="laporan") echo 'class="active"'; ?>><a href="<?=base_url()?>laporan"><i class="fa fa-list-alt"></i> <span class="kunci">Laporan</span></a></li>
			<li class="header header-warna">&nbsp;</li>
			<li <?php if($menu_a=="tipeakun") echo 'class="active"'; ?>><a href="<?=base_url('tipeakun')?>"><i class="fa fa-compress"></i> <span class="kunci">Tipe Akun</span></a></li>
			<li <?php if($menu_a=="akun") echo 'class="active"'; ?>><a href="<?=base_url('akun')?>"><i class="fa fa-credit-card"></i> <span class="kunci">Akun (COA)</span></a></li>			
			<?php /*<li <?php if($menu_a=="konfirmasi") echo 'class="active"'; ?>><a href="<?=base_url('konfirmasi')?>"><i class="fa fa-check"></i> <span class="kunci">Konfirmasi Jurnal</span></a></li> <li class="header">&nbsp;</li>*/ ?>
			<li <?php if($menu_a=="tutupbuku") echo 'class="active"'; ?>><a href="<?=base_url('tutupbuku')?>"><i class="fa fa-recycle"></i> <span class="kunci">Tutup Buku</span></a></li>
			<li class="header">&nbsp;</li>
			<li <?php if($menu_a=="pengguna") echo 'class="active"'; ?>><a href="<?=base_url('pengguna')?>"><i class="fa fa-user"></i> <span class="kunci">User</span></a></li>
		</ul>
	</section>
</aside>
