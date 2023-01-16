/*******************************************************************************
 * Copyright (c) 2006 - 2011 SJRJ.
 * 
 *     This file is part of SIGA.
 * 
 *     SIGA is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 * 
 *     SIGA is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 * 
 *     You should have received a copy of the GNU General Public License
 *     along with SIGA.  If not, see <http://www.gnu.org/licenses/>.
 ******************************************************************************/
/*
 * Criado em  21/12/2005
 *
 */
package br.gov.jfrj.siga.dp;

import javax.persistence.Cacheable;
import javax.persistence.Entity;
import javax.persistence.Table;

import br.gov.jfrj.siga.dp.dao.CpDao;
import br.gov.jfrj.siga.model.ActiveRecord;

@Entity
@Cacheable
@Table(name = "corporativo.cp_tipo_marca")
public class CpTipoMarca extends AbstractCpTipoMarca {
	public static final long TIPO_MARCA_SIGA_EX = 1;
	public static final long TIPO_MARCA_SIGA_SR = 2;
	public static final long TIPO_MARCA_SIGA_GC = 3;

	public static ActiveRecord<CpTipoMarca> AR = new ActiveRecord<>(CpTipoMarca.class);

	public static CpTipoMarca findByName(String name) {
		CpTipoMarca cpTipoMarca = null;
		if (name != null && !name.isEmpty())
			switch (name) {
			case "SIGA_EX":
				cpTipoMarca = CpDao.getInstance().consultar(1L, CpTipoMarca.class, false);
				break;
			case "SIGA_SR":
				cpTipoMarca = CpDao.getInstance().consultar(2L, CpTipoMarca.class, false);
				break;
			case "SIGA_GC":
				cpTipoMarca = CpDao.getInstance().consultar(3L, CpTipoMarca.class, false);
				break;
			case "SIGA_WF":
				cpTipoMarca = CpDao.getInstance().consultar(4L, CpTipoMarca.class, false);
				break;
			}
		return cpTipoMarca;
	}
}
