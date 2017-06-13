<section class="content-header">
	<div class="row">
		<div class="col-md-6"> <label class="label-header"></label>
		</div>
	</div>
</section>
<section class="content">
	<div class="row">
		<div class="col-lg-12">
			<form autocomplete="off" method="GET">
				<div class="box box-primary">
					<div class="box-header">
						<i class="fa fa-files-o"></i>
						<h3 class="box-title">Daftar Jurnal</h3>
					</div>
					<div class="box-body">
						<div class="row">
							<div class="col-lg-12">
								<div class="col-md-2">
									<div class="form-group">
										<label for="start_date">Tanggal Awal</label>
										<input type="text" name="tanggal_awal" id="tanggal_awal" class="form-control mulai" value="<?=$tanggal_awal?>" onkeypress="return false" readonly="" placeholder="Tanggal Awal (22-08-2011)" />
									</div>
								</div>
								<div class="col-md-2">
									<div class="form-group">
										<label for="start_date">Tanggal Akhir</label>
										<input type="text" name="tanggal_akhir" id="tanggal_akhir" class="form-control selesai" value="<?=$tanggal_akhir?>" onkeypress="return false" readonly="" placeholder="Tanggal Akhir  (31-08-2011)" />
									</div>
								</div>
								<div class="col-md-2">
									<div class="form-group">
										<label for="start_date">No Jurnal</label>
										<input type="text" name="no_jurnal" id="no_jurnal" class="form-control" value="<?=$no_jurnal?>" placeholder="No Jurnal" />
									</div>
								</div>
								<div class="col-md-2">
									<div class="form-group">
										<label for="start_date">Status Konfirmasi</label>
										<input type="text" name="status" placeholder="Status Konfirmasi" id="status" class="form-control" value="<?=$dikonfirmasi?>"  />
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-lg-12">
								<div class="col-lg-4 col-xs-10">
									<button type="submit" class="btn btn-default btn-sm"><i class="fa fa-search"></i> Cari</button>
									<button type="submit" name="btnreset" value="reset" class="btn btn-danger btn-sm"><i class="fa fa-refresh"></i> Reset</button>
									<a href="<?=base_url()?>jurnal/tambah" class="btn btn-sm btn-header btn-success"><img src="<?=base_url();?>assets/resources/add.png" /> Buat Jurnal Baru</a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12">
			<div class="box box-primary">
				<div class="box-body">
					<div class="row">
						<div class="col-lg-12">
							<table width="100%" id="dtcustomt" class="table table-striped table-bordered table-hover">
								<thead>
									<th>No</th>
									<th width="10%">Tgl Jurnal</th>
									<th>No Bukti</th>
									<th>Memo</th>
									<th>Tanggal Dibuat</th>
									<th>Tanggal Diubah</th>
									<th>Opsi</th>
								</thead>
								<tbody>

									<?php $i=1; foreach ($jurnal as $b) { ?>
				                  <tr>
				                     <td width="2%"><?php echo $i ?></td>
				                     <td><?php echo date_format(date_create($b->tgl_jurnal), 'd-m-Y') ?></td>
											<td><a href="<?=base_url('jurnal/detail/'.$b->kode_unik) ?>"><?php echo $b->no_jurnal ?></a></td>
											<td><?php echo $b->memo ?></td>
				                     <td align="center" width="10%"><span class="label label-success"><?php echo $b->tgl_dibuat ?></span></td>
				                     <td align="center" width="10%"><span class="label label-warning"><?php echo $b->tgl_diubah ?></span></td>
				                     <td align="center" width="10%">
												<a href="<?=base_url('jurnal/ubah/'.$b->kode_unik) ?>" title="Ubah Pengguna <?php echo $b->no_jurnal ?>" class="btn btn-danger btn-xs"><i class="fa fa-edit"></i> Edit</a>
												<a href="<?=base_url('jurnal/detail/'.$b->kode_unik) ?>" title="Detail <?php echo $b->no_jurnal ?>" class="btn btn-info btn-xs"><i class="fa fa-bolt"></i> Detail</a>
				                     </td>
				                  </tr>
				               <?php $i++; } ?>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>
